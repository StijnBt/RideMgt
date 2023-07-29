codeunit 50103 "Sales to Job"
{
    TableNo = "Sales Header";

    var
        Text000: Label 'An open %1 is linked to this %2. The %1 has to be closed before the %2 can be converted to an %3. Do you want to close the %1 now and continue the conversion?', Comment = 'An open Opportunity is linked to this Quote. The Opportunity has to be closed before the Quote can be converted to an Order. Do you want to close the Opportunity now and continue the conversion?';
        Text001: Label 'An open %1 is still linked to this %2. The conversion to an %3 was aborted.', Comment = 'An open Opportunity is still linked to this Quote. The conversion to an Order was aborted.';
        SalesQuoteLine: Record "Sales Line";
        Job: Record "Job";
        SalesOrderLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        RideSetup: Record "Ride Setup";
        SalesHeader: Record "Sales Header";
        JobStartDate: Date;
        JobEndDate: Date;
        JobDescription: Text[100];
        JobResponsable: Code[20];
        CreateJobPrices: Boolean;
        JobTypeCode: Code[20];
        CustomerNo: Code[20];
        FirstInvDate: Date;

    trigger OnRun()
    var
        Cust: Record Customer;
        SalesCommentLine: Record "Sales Comment Line";
        SalesLine: Record "Sales Line" temporary;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        RecordLinkManagement: Codeunit "Record Link Management";
        ShouldRedistributeInvoiceAmount: Boolean;
        IsHandled: Boolean;
        SalesQuotetoJob: Page "Sales-Quote to Job";
        ArchiveManagement: Codeunit ArchiveManagement;
        JobTaskIndent: Codeunit "Job Task-Indent";

    begin
        SalesHeader := Rec;

        OnBeforeOnRun(SalesHeader);

        RideSetup.Get();

        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.TestField("Job Type Code");
        SalesHeader.TestField(Status, SalesHeader.Status::Released);
        RideSetup.TestField("Job G/L Account Billable");

        ShouldRedistributeInvoiceAmount := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(SalesHeader);

        SalesHeader.CheckSalesPostRestrictions();

        Cust.Get(SalesHeader."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, SalesHeader."Document Type"::Order, true, false);
        Cust.TestField(Blocked, Cust.Blocked::" ");

        SalesHeader.CalcFields("Amount Including VAT", "Work Description");

        SalesHeader.ValidateSalesPersonOnSalesHeader(SalesHeader, true, false);

        SalesHeader.CheckForBlockedLines;

        CheckInProgressOpportunities(SalesHeader);

        Clear(SalesQuotetoJob);
        SalesQuotetoJob.SetSalesHeader(SalesHeader);

        SalesQuotetoJob.LookupMode(true);

        if SalesQuotetoJob.RunModal <> Action::LookupOK then
            exit;

        SalesQuotetoJob.GetSalesLines(SalesLine);

        SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);

        if SalesLine.IsEmpty then
            exit;

        SalesQuotetoJob.GetJobParams(JobStartDate, JobEndDate, JobDescription, JobResponsable, JobTypeCode, CustomerNo, CreateJobPrices, FirstInvDate);

        CreateJob();

        CreateJobDetail(SalesLine);

        JobTaskIndent.Indent(Job."No.");

        OnAfterInsertAllSalesOrderLines(SalesOrderLine, SalesHeader);

        SalesSetup.Get();
        ArchiveManagement.AutoArchiveSalesDocument(SalesHeader);
        CopyComments(SalesHeader, Job);

        RecordLinkManagement.CopyLinks(SalesHeader, Job);

        IsHandled := false;
        OnBeforeDeleteSalesQuote(SalesHeader, Job, IsHandled, SalesQuoteLine);
        if not IsHandled then begin
            ApprovalsMgmt.DeleteApprovalEntries(SalesHeader.RecordId);
            SalesHeader.DeleteLinks;
            SalesHeader.Delete;
            SalesQuoteLine.DeleteAll();
        end;

        OnAfterOnRun(SalesHeader, Job);
    end;



    local procedure CreateJob()
    begin
        Clear(Job);
        Job.Init();
        Job."No." := '';
        Job.Insert(true);

        Job.validate("Bill-to Customer No.", CustomerNo);
        Job.Validate("Job Type Code", JobTypeCode);
        Job.Validate(Description, JobDescription);
        Job.Validate("Person Responsible", JobResponsable);
        Job.Validate("Starting Date", JobStartDate);
        Job.Validate("Ending Date", JobEndDate);
        Job."Sales Quote No." := SalesHeader."No.";
        Job.Modify(true);
    end;

    local procedure CreateJobDetail(var SalesLine: Record "Sales Line")
    var
        BeginTotalTaskDesc: Label 'Head';
        EndTotalTaskDesc: Label 'Total';
        PostingTaskDescExec: Label 'Execution';
        PostingTaskBillExec: Label 'Billing';
        JobTaskNo: Code[20];
    begin
        CreateTaskLine(3, BeginTotalTaskDesc);
        JobTaskNo := CreateTaskLine(0, PostingTaskDescExec);

        if SalesLine.FindSet() then
            repeat
                CreateJobprice(SalesLine);
                CreateJobPlanningLine(SalesLine, JobTaskNo, false);
            until SalesLine.next() = 0;

        JobTaskNo := CreateTaskLine(0, PostingTaskBillExec);
        CreateJobPlanningLineBilling(JobTaskNo);
        CreateTaskLine(4, EndTotalTaskDesc);
    end;

    local procedure CreateTaskLine(JobTaskType: Option Posting,Heading,Total,"Begin-Total","End-Total"; Description: Text[100]): Code[20];
    var
        JobTask: Record "Job Task";
        NewLineNo: Integer;
        CurrentLine: Integer;
        TextHelper: Text;
    begin
        JobTask.Reset();
        JobTask.SetRange("Job No.", Job."No.");

        if JobTask.FindLast() then begin
            Evaluate(CurrentLine, JobTask."Job Task No.");
        end else begin
            CurrentLine := 0;
            Clear(JobTask);
        end;


        case JobTaskType of
            JobTaskType::Posting:
                NewLineNo := CurrentLine + 10;
            JobTaskType::"Begin-Total", JobTaskType::"End-Total":
                NewLineNo := Round(CurrentLine + 1, 100, '>');
            JobTaskType::Heading:
                NewLineNo := Round(CurrentLine + 1, 1000, '<'); //currentline should be 0
            JobTaskType::Total:
                NewLineNo := Round(CurrentLine + 1, 1000, '>');
        end;

        TextHelper := Format(NewLineNo);

        Clear(JobTask);
        JobTask.Init();
        JobTask.Validate("Job No.", Job."No.");
        JobTask.Validate("Job Task No.", TextHelper.PadLeft(6, '0'));
        JobTask.Insert(true);

        JobTask.Description := Description;
        JobTask.Validate("Job Task Type", JobTaskType);

        if JobTaskType = JobTaskType::Posting then
            JobTask.validate("WIP-Total", JobTask."WIP-Total"::Excluded);
        JobTask.Modify(true);


        exit(JobTask."Job Task No.");
    end;

    local procedure CreateJobPlanningLineBilling(JobTaskNo: Code[20])
    var
        SalesLine: Record "Sales Line";
    begin

        SalesHeader.CalcFields(Amount, "Amount Including VAT");

        Clear(SalesLine);
        SalesLine.Type := SalesLine.Type::"G/L Account";
        SalesLine."No." := RideSetup."Job G/L Account Billable";
        SalesLine."Qty. to Ship" := 1;
        SalesLine."Unit Price" := SalesHeader.Amount;
        SalesLine."Shipment Date" := FirstInvDate;

        CreateJobPlanningLine(SalesLine, JobTaskNo, true);
    end;

    local procedure CreateJobPlanningLine(SalesLine: Record "Sales Line"; JobTaskNo: Code[20]; Billable: Boolean)
    var
        JobPlanningLine: Record "Job Planning Line";
        NewLineNo: Integer;
    begin
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", Job."No.");
        JobPlanningLine.SetRange("Job Task No.", JobTaskNo);

        If not JobPlanningLine.FindLast() then
            Clear(JobPlanningLine);

        NewLineNo := JobPlanningLine."Line No." + 10000;

        Clear(JobPlanningLine);
        JobPlanningLine.Init();
        JobPlanningLine.Validate("Job No.", Job."No.");
        JobPlanningLine.Validate("Job Task No.", JobTaskNo);
        JobPlanningLine.Validate("Line No.", NewLineNo);
        JobPlanningLine.Insert(true);

        if Billable then
            JobPlanningLine.Validate("Line Type", JobPlanningLine."Line Type"::Billable)
        else
            JobPlanningLine.Validate("Line Type", JobPlanningLine."Line Type"::Budget);

        case SalesLine.Type of
            Salesline.type::"G/L Account":
                JobPlanningLine.validate(Type, JobPlanningLine.Type::"G/L Account");
            Salesline.type::"Item":
                JobPlanningLine.validate(Type, JobPlanningLine.Type::"Item");
            Salesline.type::"Resource":
                JobPlanningLine.validate(Type, JobPlanningLine.Type::"Resource");
        end;

        JobPlanningLine.Validate("No.", SalesLine."No.");
        JobPlanningLine.Validate(Quantity, SalesLine."Qty. to Ship");

        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            JobPlanningLine.Validate("Work Type Code", SalesLine."Work Type Code");

        if Billable then
            JobPlanningLine.validate("Unit Price", SalesLine."Unit Price");

        JobPlanningLine.Validate("Planning Date", JobStartDate);
        JobPlanningLine.Validate("Document No.", SalesLine."Document No.");
        JobPlanningLine.Modify(true)
    end;

    local procedure CreateJobprice(SalesLine: Record "Sales Line")
    var
        JobResourcePrice: Record "Job Resource Price";
        JobItemPrice: Record "Job Item Price";
        Resource: Record Resource;
    begin

        case SalesLine.Type of
            SalesLine.Type::Item:
                begin
                    JobItemPrice.Reset();
                    JobItemPrice.SetRange("Job No.", Job."No.");
                    JobItemPrice.SetRange("Item No.", SalesLine."No.");
                    JobItemPrice.SetRange("Unit of Measure Code", SalesLine."Unit of Measure Code");
                    JobItemPrice.SetRange("Variant Code", SalesLine."Variant Code");
                    JobItemPrice.SetRange("Currency Code", SalesLine."Currency Code");

                    if not JobItemPrice.IsEmpty then
                        exit;

                    Clear(JobItemPrice);
                    JobItemPrice.Init();
                    JobItemPrice.Validate("Job No.", Job."No.");
                    JobItemPrice.Validate("Item No.", SalesLine."No.");
                    JobItemPrice.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                    JobItemPrice.Validate("Variant Code", SalesLine."Variant Code");
                    JobItemPrice.Validate("Currency Code", SalesLine."Currency Code");
                    JobItemPrice.Insert(true);

                    JobItemPrice.Description := SalesLine.Description;
                    JobItemPrice.Validate("Unit Price", SalesLine."Unit Price");
                    JobItemPrice.Modify(true);
                end;
            SalesLine.Type::Resource:
                begin
                    if not Resource.get(SalesLine."No.") then
                        Clear(Resource);

                    if Resource.Template and (Resource."Resource Group No." = '') then
                        exit;

                    Clear(JobResourcePrice);
                    JobResourcePrice.Init();
                    JobResourcePrice.Validate("Job No.", Job."No.");
                    if Resource.Template then begin
                        JobResourcePrice.Validate(Type, JobResourcePrice.Type::"Group(Resource)");
                        JobResourcePrice.Validate(Code, Resource."Resource Group No.");
                    end else begin
                        JobResourcePrice.Validate(Type, JobResourcePrice.Type::Resource);
                        JobResourcePrice.Validate(Code, SalesLine."No.");
                    end;

                    JobResourcePrice.Validate("Work Type Code", SalesLine."Work Type Code");
                    JobResourcePrice.Insert(true);

                    JobResourcePrice.Description := SalesLine.Description;
                    JobResourcePrice.Validate("Unit Price", SalesLine."Unit Price");
                    JobResourcePrice.Modify(true);
                end;
        end;

    end;

    procedure CopyComments(SalesHeader: Record "Sales Header"; Job: Record Job)
    var
        SalesCommentLine: Record "Sales Comment Line";
        CommentLine: Record "Comment Line";
    begin
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesCommentLine.SetRange("No.", SalesHeader."No.");
        SalesCommentLine.SetFilter(Comment, '<>%1', '');

        if SalesCommentLine.FindSet() then
            repeat
                clear(CommentLine);
                CommentLine.Init();
                CommentLine."Table Name" := CommentLine."Table Name"::Job;
                CommentLine."No." := Job."No.";
                CommentLine."Line No." := SalesCommentLine."Line No.";
                CommentLine.Insert(true);

                CommentLine.Code := SalesCommentLine.Code;
                CommentLine.Date := SalesCommentLine.Date;
                CommentLine.Comment := SalesCommentLine.Comment;
                CommentLine.Modify(true);
            until SalesCommentLine.Next() = 0;
    end;

    procedure GetJob(var Job2: Record Job)
    begin
        Job2 := Job;
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        if NewHideValidationDialog then
            exit;
    end;

    local procedure CheckInProgressOpportunities(var SalesHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        Opp.Reset();
        Opp.SetCurrentKey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."Sales Document Type"::Quote);
        Opp.SetRange("Sales Document No.", SalesHeader."No.");
        Opp.SetRange(Status, Opp.Status::"In Progress");
        if Opp.FindFirst then begin
            if not ConfirmManagement.GetResponseOrDefault(
                 StrSubstNo(
                   Text000, Opp.TableCaption, Opp."Sales Document Type"::Quote,
                   Opp."Sales Document Type"::Order), true)
            then
                Error('');
            TempOpportunityEntry.DeleteAll();
            TempOpportunityEntry.Init();
            TempOpportunityEntry.Validate("Opportunity No.", Opp."No.");
            TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
            TempOpportunityEntry."Contact No." := Opp."Contact No.";
            TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
            TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
            TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
            TempOpportunityEntry."Action Taken" := TempOpportunityEntry."Action Taken"::Won;
            TempOpportunityEntry."Calcd. Current Value (LCY)" := TempOpportunityEntry.GetSalesDocValue(SalesHeader);
            TempOpportunityEntry."Cancel Old To Do" := true;
            TempOpportunityEntry."Wizard Step" := 1;
            OnBeforeTempOpportunityEntryInsert(TempOpportunityEntry);
            TempOpportunityEntry.Insert();
            TempOpportunityEntry.SetRange("Action Taken", TempOpportunityEntry."Action Taken"::Won);
            PAGE.RunModal(PAGE::"Close Opportunity", TempOpportunityEntry);
            Opp.Reset();
            Opp.SetCurrentKey("Sales Document Type", "Sales Document No.");
            Opp.SetRange("Sales Document Type", Opp."Sales Document Type"::Quote);
            Opp.SetRange("Sales Document No.", SalesHeader."No.");
            Opp.SetRange(Status, Opp.Status::"In Progress");
            if Opp.FindFirst then
                Error(Text001, Opp.TableCaption, Opp."Sales Document Type"::Quote, Opp."Sales Document Type"::Order);
            Commit();
            SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesHeader(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteSalesQuote(var QuoteSalesHeader: Record "Sales Header"; var Job: Record "Job"; var IsHandled: Boolean; var SalesQuoteLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertJob(var Job: Record "Job"; SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifyJob(var Job: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertJob(var Job: Record "Job"; SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertAllSalesOrderLines(var SalesOrderLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnRun(var SalesHeader: Record "Sales Header"; var Job: Record "Job")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeArchiveSalesQuote(var SalesQuoteHeader: Record "Sales Header"; var Job: Record "Job"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesOrderLine(var SalesOrderLine: Record "Sales Line"; SalesOrderHeader: Record "Sales Header"; SalesQuoteLine: Record "Sales Line"; SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnRun(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTempOpportunityEntryInsert(var TempOpportunityEntry: Record "Opportunity Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTransferQuoteLineToOrderLineLoop(var SalesQuoteLine: Record "Sales Line"; var SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTransferQuoteToOrderLinesOnAfterSetFilters(var SalesQuoteLine: Record "Sales Line"; var SalesQuoteHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateJob(var Job: Record "Job"; SalesHeader: Record "Sales Header")
    begin
    end;
}

