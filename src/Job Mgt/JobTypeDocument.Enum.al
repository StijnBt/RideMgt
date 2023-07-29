enum 50100 "Job Type Document"
{
    Extensible = true;

    value(0; Empty)
    {
        Caption = '';
    }
    value(1; Job)
    {
        Caption = 'Job';
    }
    value(2; Invoice)
    {
        Caption = 'Invoice';
    }
}