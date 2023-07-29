codeunit 50106 "Finish Quote"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        FinishQuote(Rec, true);
    end;

    procedure FinishQuote(var SalesHeader: Record "Sales Header"; HideDialog: Boolean);
    var
        Handled: Boolean;
    begin
        if not ConfirmFinishQuote(SalesHeader, HideDialog) then
            exit;

        OnBeforeFinishQuote(SalesHeader, Handled);
        DoFinishQuote(SalesHeader, Handled);
        OnAfterFinishQuote(SalesHeader);
        AcknowledgeFinishQuote(SalesHeader, HideDialog)
    end;

    local procedure DoFinishQuote(var SalesHeader: Record "Sales Header"; Handled: Boolean);
    var
        JobType: Record "Job Type";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        if Handled then
            exit;

        if not JobType.Get(SalesHeader."Job Type Code") or (JobType.Document = JobType.Document::Empty) then
            exit;

        case JobType.Document of
            JobType.Document::Invoice:
                if ApprovalsMgmt.PrePostApprovalCheckSales(SalesHeader) then begin
                    if ApplicationAreaMgmtFacade.IsFoundationEnabled then
                        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
                    CODEUNIT.Run(CODEUNIT::"Sales-Quote to Invoice Yes/No", SalesHeader);
                end;
            JobType.Document::Job:
                if ApprovalsMgmt.PrePostApprovalCheckSales(SalesHeader) then
                    CODEUNIT.Run(CODEUNIT::"Sales to Job (Yes/No)", SalesHeader);
        end;
    end;

    local procedure ConfirmFinishQuote(var SalesHeader: Record "Sales Header"; HideDialog: Boolean): Boolean
    var
        ConfirmQst: label 'Are You Sure?';
    begin
        if Not GuiAllowed or HideDialog then
            exit(true);

        exit(Confirm(ConfirmQst));
    end;

    local procedure AcknowledgeFinishQuote(var SalesHeader: Record "Sales Header"; HideDialog: Boolean)
    var
        AcknowledgeMsg: label 'You successfully executed "Finish Quote"';
    begin
        if Not GuiAllowed or HideDialog then exit;
        Message(AcknowledgeMsg);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFinishQuote(var SalesHeader: Record "Sales Header"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFinishQuote(var SalesHeader: Record "Sales Header");
    begin
    end;
}