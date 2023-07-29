page 50103 "Sales-Quote to Job"
{

    Caption = 'Sales-Quote to Job';
    PageType = Worksheet;
    SourceTable = "Sales Line";
    SourceTableTemporary = true;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(Options)
            {
                ShowCaption = false;

                group(Customer)
                {
                    Caption = 'Customer';


                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Customer;
                        Caption = 'Customer No.';
                    }
                    field(JobTypeCode; JobTypeCode)
                    {
                        ApplicationArea = All;
                        TableRelation = "Job Type";
                        Caption = 'Job Type';
                    }
                    field(JobDescription; JobDescription)
                    {
                        ApplicationArea = All;
                        Caption = 'Job Description';
                    }
                }
                group(Job)
                {
                    Caption = 'Job';

                    field(JobStartDate; JobStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';

                        trigger OnValidate()
                        begin
                            ValidateStartEndDates();
                        end;
                    }
                    field(JobEndDate; JobEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            ValidateStartEndDates();

                        end;
                    }
                    field(JobResponsable; JobResponsable)
                    {
                        ApplicationArea = All;
                        TableRelation = Resource;
                        Caption = 'Job Responsable';
                        Visible = false;
                    }

                    field(FirstInvDate; FirstInvDate)
                    {
                        ApplicationArea = All;
                        Caption = 'First Invoice Date';
                    }


                    field(CreateJobPrices; CreateJobPrices)
                    {
                        ApplicationArea = All;
                        Caption = 'Create Job Prices';
                    }
                }

            }
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Caption = 'Quantity to Job';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [Action::LookupOK, Action::OK] then
            CheckMandatoryFields();
    end;

    trigger OnOpenPage()
    begin
        InitPage();
    end;

    local procedure CheckMandatoryFields()
    var
        DatesErr: Label 'Ending & Starting date are mandatory';
        JobDescErr: Label 'Job description is mandatory';
        JobTypeCodeErr: Label 'Job type code is mandatory';
        CustomerNoErr: Label 'Customer No. is mandatory';
        FirstInvDateErr: Label 'First invoice date is mandatory';
    begin
        if (JobStartDate = 0D) or (JobEndDate = 0D) then
            Error(DatesErr);

        If (JobDescription = '') then
            Error(JobDescErr);

        if (JobTypeCode = '') then
            Error(JobTypeCodeErr);

        if (CustomerNo = '') then
            Error(CustomerNoErr);

        if (FirstInvDate = 0D) then
            Error(FirstInvDateErr);
    end;

    procedure SetSalesHeader(var SalesHeader2: Record "Sales Header")
    begin
        SalesHeader := SalesHeader2;
    end;

    procedure GetSalesLines(var SalesLine2: record "Sales Line")
    begin
        if not SalesLine2.IsTemporary then
            Error('SetSalesLine SalesLine variable should be temporary');

        if rec.FindSet() then
            repeat
                SalesLine2 := rec;
                SalesLine2.Insert();
            until rec.Next() = 0;
    end;



    local procedure InitPage()
    var
        SalesLine: Record "Sales Line";
        InStr: InStream;
        WorkDesc: Text;

    begin
        SalesHeader.calcfields("Work Description");
        SalesHeader."Work Description".CreateInStream(InStr);
        InStr.ReadText(WorkDesc);

        CustomerNo := SalesHeader."Sell-to Customer No.";
        JobTypeCode := SalesHeader."Job Type Code";
        JobDescription := CopyStr(WorkDesc, 1, MaxStrLen(JobDescription));
        JobStartDate := SalesHeader."Requested Delivery Date";
        JobEndDate := JobStartDate;
        CreateJobPrices := true;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '%1|%2', SalesLine.Type::Item, SalesLine.Type::Resource);

        if SalesLine.FindSet() then
            repeat
                Clear(Rec);
                Rec.Init();
                Rec := SalesLine;
                Rec.Insert();
            until SalesLine.Next() = 0;

    end;

    procedure GetJobParams(var JobStartDate2: Date; var JobEndDate2: Date; var JobDescription2: text; var JobResponsable2: code[20]; var JobTypeCode2: code[20]; var CustomerNo2: code[20]; var CreateJobPrices2: Boolean; var FirstInvDate2: Date)
    begin
        JobStartDate2 := JobStartDate;
        JobEndDate2 := JobEndDate;
        JobDescription2 := JobDescription;
        JobResponsable2 := JobResponsable;
        JobTypeCode2 := JobTypeCode;
        CustomerNo2 := CustomerNo;
        CreateJobPrices2 := CreateJobPrices;
        FirstInvDate2 := FirstInvDate;
    end;

    procedure ValidateStartEndDates()
    var
        DateErr: Label 'Startdate should be before Enddate';
    begin
        if (JobStartDate <> 0D) and ((JobStartDate > JobEndDate) and (JobEndDate <> 0D)) then
            Error(DateErr);

        if JobEndDate = 0D then
            JobEndDate := JobStartDate;
    end;

    var
        SalesHeader: Record "Sales Header";
        JobStartDate: Date;
        JobEndDate: Date;
        JobDescription: Text[100];
        JobResponsable: Code[20];
        CreateJobPrices: Boolean;
        JobTypeCode: Code[20];
        CustomerNo: Code[20];
        FirstInvDate: Date;
}
