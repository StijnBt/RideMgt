codeunit 50102 "Sales to Job (Yes/No)"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        OfficeMgt: Codeunit "Office Management";
        JobCard: Page "Job Card";
        OpenPage: Boolean;
    begin
        if IsOnRunHandled(Rec) then
            exit;

        Rec.TestField("Document Type", Rec."Document Type"::Quote);

        if GuiAllowed then
            if not Confirm(ConfirmConvertToOrderQst, false) then
                exit;

        if Rec.CheckCustomerCreated(true) then
            Rec.Get(Rec."Document Type"::Quote, Rec."No.")
        else
            exit;

        SalesQuoteToJob.Run(Rec);
        SalesQuoteToJob.GetJob(Job);

        if Job."No." = '' then
            exit;

        Commit();

        OnAfterSalesQuoteToJobRun(Job);

        if GuiAllowed then
            if OfficeMgt.AttachAvailable then
                OpenPage := true
            else
                OpenPage := Confirm(StrSubstNo(OpenNewJobQst, Job."No."), true);
        if OpenPage then begin
            Clear(JobCard);
            //JobCard.CheckNotificationsOnce;
            JobCard.SetRecord(Job);
            JobCard.Run;
        end;
    end;

    var
        ConfirmConvertToOrderQst: Label 'Do you want to convert the quote to a job?';
        OpenNewJobQst: Label 'The quote has been converted to job %1. Do you want to open the new job?', Comment = '%1 = No. of the new job.';
        Job: Record "Job";
        SalesQuoteToJob: Codeunit "Sales to Job";

    local procedure IsOnRunHandled(var SalesHeader: Record "Sales Header") IsHandled: Boolean
    begin
        IsHandled := false;
        OnBeforeRun(SalesHeader, IsHandled);
        exit(IsHandled);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesQuoteToJobRun(var Job: Record "Job")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRun(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;
}


