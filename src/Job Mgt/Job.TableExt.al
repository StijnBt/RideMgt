tableextension 50100 "Job" extends Job
{
    fields
    {
        field(50100; "Job Type Code"; Code[20])
        {
            Caption = 'Job Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Job Type";
        }

        field(50101; "Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }


    procedure OnDrillDownSalesQuoteNo()
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        PageManagement: Codeunit "Page Management";
    begin

        if SalesHeader.get(SalesHeader."Document Type"::Quote, "Sales Quote No.") then
            PageManagement.PageRun(SalesHeader)
        else begin
            SalesHeaderArchive.Reset();
            SalesHeaderArchive.SetCurrentKey("Document Type", "No.", "Doc. No. Occurrence", "Version No.");
            SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type");
            SalesHeaderArchive.SetRange("No.", "Sales Quote No.");

            IF SalesHeaderArchive.FindLast() then
                PageManagement.PageRun(SalesHeaderArchive);
        end;



    end;
}
