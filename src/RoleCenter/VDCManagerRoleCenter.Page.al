page 50101 "VDC Manager Role Center"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part("Headline RC Project Manager"; "Headline RC Project Manager")
            {
                ApplicationArea = All;
            }

            part("VDC Manager Cue"; "VDC Manager Cue")
            {
                ApplicationArea = All;
            }

            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = All;
            }

            part("My Jobs"; "My Jobs")
            {
                ApplicationArea = All;
                Visible = false;
            }
            part("Job Actual Price to Budget Price"; "Job Act to Bud Price Chart")
            {
                ApplicationArea = All;
                Caption = 'Job Actual Price to Budget Price';
                //Visible = false;
            }
            part("Job Profitability"; "Job Profitability Chart")
            {
                ApplicationArea = All;
                Caption = 'Job Profitability';
                //Visible = false;
            }
            part("Job Actual Cost to Budget Cost"; "Job Act to Bud Cost Chart")
            {
                ApplicationArea = All;
                Caption = 'Job Actual Cost to Budget Cost';
                //Visible = false;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                Visible = false;
            }
            part("Power BI Report Spinner Part"; "Power BI Report Spinner Part")
            {
                AccessByPermission = TableData "Power BI User Configuration" = I;
                ApplicationArea = All;
                Visible = false;
            }
            part(Control21; "My Job Queue")
            {
                ApplicationArea = Jobs;
                Visible = false;
            }
            part(Control31; "Report Inbox Part")
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(embedding)
        {

        }
        area(sections)
        {
            group(Action2)
            {
                Caption = 'Operations';
                Image = Job;
                ToolTip = 'Operations';

                action(SalesQuotes)
                {
                    ApplicationArea = All;
                    Caption = 'Quotes';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Quotes";
                    ToolTip = 'Quotes';
                }
                action(Action90)
                {
                    ApplicationArea = All;
                    Caption = 'Jobs';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job List";
                    ToolTip = 'Define a project activity by creating a job card with integrated job tasks and job planning lines, structured in two layers. The job task enables you to set up job planning lines and to post consumption to the job. The job planning lines specify the detailed use of resources, items, and various general ledger expenses.';
                }
                action(SalesInvoices)
                {
                    ApplicationArea = All;
                    Caption = 'Pending invoices';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Invoice List";
                    ToolTip = 'Pending invoices';
                }

                action(Action3)
                {
                    ApplicationArea = All;
                    Caption = 'Job Tasks';
                    Visible = false;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Task List";
                    ToolTip = 'Open the list of ongoing job tasks. Job tasks represent the actual work that is performed in a job, and they enable you to set up job planning lines and to post consumption to the job.';
                }
                action("Job Planning Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Job Planning Lines';
                    Promoted = true;
                    Visible = false;
                    PromotedCategory = Process;
                    RunObject = Page "Job Planning Lines";
                    ToolTip = 'Open the list of ongoing job planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).';
                }


            }

            group(Crm)
            {
                Caption = 'Crm';
                Image = CashFlow;
                ToolTip = 'Crm';

                action(Customers)
                {
                    ApplicationArea = All;
                    Caption = 'Customers';
                    Image = Customer;
                    RunObject = Page "Customer List";
                    ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
                }

                action(Vendors)
                {
                    ApplicationArea = All;
                    Caption = 'Vendors';
                    Image = Vendor;
                    RunObject = Page "Vendor List";
                    ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
                }

                action(Contacts)
                {
                    ApplicationArea = All;
                    Caption = 'Contacts';
                    Image = Vendor;
                    RunObject = Page "Contact List";
                    ToolTip = 'Contacts';
                }

            }
            group(Action91)
            {
                Caption = 'Resources & Items';
                Image = Journals;
                ToolTip = 'Manage the people, machines & items that are used to perform job tasks. ';
                action(Action93)
                {
                    ApplicationArea = All;
                    Caption = 'Resources';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource List";
                    ToolTip = 'Manage your resources'' job activities by setting up their costs and prices. The job-related prices, discounts, and cost factor rules are set up on the respective job card. You can specify the costs and prices for individual resources, resource groups, or all available resources of the company. When resources are used or sold in a job, the specified prices and costs are recorded for the project.';
                }
                action("Resource Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Groups';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Groups";
                    ToolTip = 'Organize resources in groups, such as Consultants, for easier assignment of common values and to analyze financial figures by groups.';
                }

                action(Items)
                {
                    ApplicationArea = All;
                    Caption = 'Items';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Item;
                    RunObject = Page "Item List";
                    ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                }

                action(StdSalesCodes)
                {
                    ApplicationArea = All;
                    Caption = 'Standard Sales Codes';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Item;
                    RunObject = Page "Standard Sales Codes";
                }

            }

            group(Hrm)
            {
                Caption = 'Hrm';
                Image = HumanResources;
                ToolTip = 'Hrm';

                action(Employees)
                {
                    ApplicationArea = All;
                    Caption = 'Employees';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Employee;
                    RunObject = Page "Employee List";
                    ToolTip = 'Employees';
                }

                action(EmployeesAbsence)
                {
                    ApplicationArea = All;
                    Caption = 'Absence Registration';
                    Promoted = true;
                    PromotedCategory = Process;
                    Image = Absence;
                    RunObject = Page "Absence Registration";
                    ToolTip = 'Absence Registration';
                }


            }
            group("Journals")
            {
                action(JobJournals)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Job Journals';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    ToolTip = 'Record job expenses or usage in the job ledger, either by reusing job planning lines or by manual entry.';
                }
                action(ResourceJournals)
                {
                    ApplicationArea = All;
                    Caption = 'Resource Journals';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Jnl. Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                    ToolTip = 'Post usage and sales of your resources for internal use and statistics. Use time sheet entries as input. Note that unlike with job journals, entries posted with resource journals are not posted to G/L accounts.';
                }
            }

            group("Posted Archived Documents")
            {
                Caption = 'Posted & Archived Documents';
                Image = FiledPosted;
                ToolTip = 'View the posting history/archive for sales, shipments, and inventory.';
                action("Posted Sales Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                    Visible = false;
                }

                action("Sales Quote Archives")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Quote Archives';
                    RunObject = Page "Sales Quote Archives";
                    ToolTip = 'Open the list of Sales Quote Archives.';
                }


                action("Job Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Job Ledger Entries';
                    RunObject = Page "Job Ledger Entries";
                    ToolTip = 'Job Ledger Entries';
                }

                action("Employee Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Ledger Entries';
                    RunObject = Page "Employee Ledger Entries";
                    ToolTip = 'Employee Ledger Entries';
                }

                action("Resource Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Resource Ledger Entries';
                    RunObject = Page "Resource Ledger Entries";
                    ToolTip = 'Resource Ledger Entries';
                }

                action("General Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'General Ledger Entries';
                    RunObject = Page "General Ledger Entries";
                    ToolTip = 'General Ledger Entries';
                }
            }
            group(SetupAndExtensions)
            {
                Caption = 'Setup & Extensions';
                Image = Setup;
                ToolTip = 'Overview and change system and application settings, and manage extensions and services';

                action("Company Information")
                {
                    ApplicationArea = All;
                    Caption = 'Company Information';
                    Image = Company;
                    RunObject = Page "Company Information";
                    ToolTip = 'Company Information';
                }

                action("Ride Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Ride Setup';
                    Image = Administration;
                    RunObject = Page "Ride Setup";
                    ToolTip = 'Ride Setup';
                }

                action(DataExchDef)
                {
                    ApplicationArea = All;
                    Caption = 'Data Exchange Definitions';
                    Image = Administration;
                    RunObject = Page "Data Exch Def List";
                    ToolTip = 'Data Exchange Definitions';
                }

                action("Assisted Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Assisted Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Assisted Setup";
                    ToolTip = 'Set up core functionality such as sales tax, sending documents as email, and approval workflow by running through a few pages that guide you through the information.';
                }
                action("Manual Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Manual Setup';
                    RunObject = Page "Manual Setup";
                    ToolTip = 'Define your company policies for business departments and for general activities by filling setup windows manually.';
                }

                action("Report Layout Selection")
                {
                    ApplicationArea = All;
                    Caption = 'Report Layout Selection';
                    RunObject = Page "Report Layout Selection";
                    ToolTip = 'Report Layout Selection';
                }

                action("Custom Report Layouts")
                {
                    ApplicationArea = All;
                    Caption = 'Custom Report Layouts';
                    RunObject = Page "Custom Report Layouts";
                    ToolTip = 'Custom Report Layouts';
                }



                action("Service Connections")
                {
                    ApplicationArea = All;
                    Caption = 'Service Connections';
                    Image = ServiceTasks;
                    RunObject = Page "Service Connections";
                    ToolTip = 'Enable and configure external services, such as exchange rate updates, Microsoft Social Engagement, and electronic bank integration.';
                }
                action(Extensions)
                {
                    ApplicationArea = All;
                    Caption = 'Extensions';
                    Image = NonStockItemSetup;
                    RunObject = Page "Extension Management";
                    ToolTip = 'Install Extensions for greater functionality of the system.';
                }
                action(Workflows)
                {
                    ApplicationArea = All;
                    Caption = 'Workflows';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Workflows;
                    ToolTip = 'Set up or enable workflows that connect business-process tasks performed by different users. System tasks, such as automatic posting, can be included as steps in workflows, preceded or followed by user tasks. Requesting and granting approval to create new records are typical workflow steps.';
                }

                action(ConfigPackages)
                {
                    ApplicationArea = All;
                    Caption = 'Configuration Packages';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Config. Packages";
                    ToolTip = 'Configuration Packages';
                }
            }
        }
        area(processing)
        {
            group(NewGroup)
            {
                Caption = 'New';
                action("Page Job")
                {
                    AccessByPermission = TableData Job = IMD;
                    ApplicationArea = All;
                    Caption = 'Job';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Job Creation Wizard";
                    RunPageMode = Create;
                    ToolTip = 'Create a new job.';
                }
                action("Job &Create Sales Invoice")
                {
                    AccessByPermission = TableData "Job Task" = IMD;
                    ApplicationArea = All;
                    Caption = 'Job &Create Sales Invoice';
                    Image = CreateJobSalesInvoice;
                    RunObject = Report "Job Create Sales Invoice";
                    ToolTip = 'Use a function to automatically create a sales invoice for one or more jobs.';
                }
                action("Update Job I&tem Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Update Job I&tem Cost';
                    Image = "Report";
                    RunObject = Report "Update Job Item Cost";
                    ToolTip = 'Use a function to automatically update the cost of items used in jobs.';
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                group("Job Reports")
                {
                    Caption = 'Job Reports';
                    Image = ReferenceData;
                    action("Job &Analysis")
                    {
                        ApplicationArea = All;
                        Caption = 'Job &Analysis';
                        Image = "Report";
                        RunObject = Report "Job Analysis";
                        ToolTip = 'Analyze your jobs. For example, you can create a report that shows you the scheduled prices, usage prices, and contract prices, and then compares the three sets of prices.';
                    }
                    action("Job Actual To &Budget")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Actual To &Budget';
                        Image = "Report";
                        RunObject = Report "Job Actual To Budget";
                        ToolTip = 'Compare scheduled and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.';
                    }
                    action("Job - Pla&nning Line")
                    {
                        ApplicationArea = All;
                        Caption = 'Job - Pla&nning Line';
                        Image = "Report";
                        RunObject = Report "Job - Planning Lines";
                        ToolTip = 'Define job tasks to capture any information that you want to track for a job. You can use planning lines to add information such as what resources are required or to capture what items are needed to perform the job.';
                    }
                    separator(Action16)
                    {
                    }
                    action("Job Su&ggested Billing")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Su&ggested Billing';
                        Image = "Report";
                        RunObject = Report "Job Suggested Billing";
                        ToolTip = 'View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.';
                    }
                    action("Jobs per &Customer")
                    {
                        ApplicationArea = All;
                        Caption = 'Jobs per &Customer';
                        Image = "Report";
                        RunObject = Report "Jobs per Customer";
                        ToolTip = 'View a list of all jobs, grouped by customer where you can compare the scheduled price, the percentage of completion, the invoiced price, and the percentage of invoiced amounts for each bill-to customer.';
                    }
                    action("Items per &Job")
                    {
                        ApplicationArea = All;
                        Caption = 'Items per &Job';
                        Image = "Report";
                        RunObject = Report "Items per Job";
                        ToolTip = 'View which items are used for which jobs.';
                    }
                    action("Jobs per &Item")
                    {
                        ApplicationArea = All;
                        Caption = 'Jobs per &Item';
                        Image = "Report";
                        RunObject = Report "Jobs per Item";
                        ToolTip = 'View on which job a specific item is used.';
                    }
                }
                group("Absence Reports")
                {
                    Caption = 'Absence Reports';
                    Image = ReferenceData;
                    ToolTip = 'Analyze employee absence.';
                    action("Employee - Staff Absences")
                    {
                        ApplicationArea = All;
                        Caption = 'Employee - Staff Absences';
                        Image = "Report";
                        RunObject = Report "Employee - Staff Absences";
                        ToolTip = 'View a list of employee absences by date. The list includes the cause of each employee absence.';
                    }
                    action("Employee - Absences by Causes")
                    {
                        ApplicationArea = All;
                        Caption = 'Employee - Absences by Causes';
                        Image = "Report";
                        RunObject = Report "Employee - Absences by Causes";
                        ToolTip = 'View a list of all your employee absences categorized by absence code.';
                    }
                }
            }
            group(Manage)
            {
                Caption = 'Manage';
                group(Timesheet)
                {
                    Caption = 'Time Sheet';
                    Image = Worksheets;
                    Visible = false;
                    action("Create Time Sheets")
                    {
                        AccessByPermission = TableData "Time Sheet Header" = IMD;
                        ApplicationArea = All;
                        Caption = 'Create Time Sheets';
                        Image = JobTimeSheet;
                        RunObject = Report "Create Time Sheets";
                        ToolTip = 'As the time sheet administrator, create time sheets for resources that have the Use Time Sheet check box selected on the resource card. Afterwards, view the time sheets that you have created in the Time Sheets window.';
                    }
                    action("Manage Time Sheets")
                    {
                        AccessByPermission = TableData "Time Sheet Header" = IMD;
                        ApplicationArea = All;
                        Caption = 'Manager Time Sheets';
                        Image = JobTimeSheet;
                        RunObject = Page "Manager Time Sheet";
                        ToolTip = 'Approve or reject your resources'' time sheet entries in a window that contains lines for all time sheets that resources have submitted for review.';
                    }
                    action("Manager Time Sheet by Job")
                    {
                        AccessByPermission = TableData "Time Sheet Line" = IMD;
                        ApplicationArea = All;
                        Caption = 'Manager Time Sheet by Job';
                        Image = JobTimeSheet;
                        RunObject = Page "Manager Time Sheet by Job";
                        ToolTip = 'Open the list of time sheets for which your name is filled into the Person Responsible field on the related job card.';
                    }
                    separator(Action5)
                    {
                    }
                    separator(Action7)
                    {
                    }
                }
                group(ResourceCapacity)
                {
                    Caption = 'Capacity & Availability';
                    Image = ResourcePlanning;
                    ToolTip = 'Capacity & Availability';
                    action("Resource Capacity")
                    {
                        ApplicationArea = All;
                        Caption = 'Resource Capacity';
                        Image = Capacity;
                        RunObject = page "Resource Capacity";
                        ToolTip = 'Resource Capacity';
                    }

                    action("Resource Availability")
                    {
                        ApplicationArea = All;
                        Caption = 'Resource Availability';
                        Image = AvailableToPromise;
                        RunObject = page "Resource Availability";
                        ToolTip = 'Resource Availability';
                    }

                    action("Base Calendar List")
                    {
                        ApplicationArea = All;
                        Caption = 'Base Calendar List';
                        Image = Calendar;
                        RunObject = page "Base Calendar List";
                        ToolTip = 'Base Calendar List';
                    }

                    action("Work-Hour Templates")
                    {
                        ApplicationArea = All;
                        Caption = 'Work-Hour Templates';
                        Image = Workdays;
                        RunObject = page "Work-Hour Templates";
                        ToolTip = 'Work-Hour Templates';
                    }
                }
                group(WIP)
                {
                    Caption = 'Job Closing';
                    Image = Job;
                    ToolTip = 'Perform various post-processing of jobs.';
                    action("Job Calculate &WIP")
                    {
                        ApplicationArea = All;
                        Caption = 'Job Calculate &WIP';
                        Image = CalculateWIP;
                        RunObject = Report "Job Calculate WIP";
                        ToolTip = 'Calculate the general ledger entries needed to update or close the job.';
                    }
                    action("Jo&b Post WIP to G/L")
                    {
                        ApplicationArea = All;
                        Caption = 'Jo&b Post WIP to G/L';
                        Image = PostOrder;
                        RunObject = Report "Job Post WIP to G/L";
                        ToolTip = 'Post to the general ledger the entries calculated for your jobs.';
                    }
                    action("Job WIP")
                    {
                        ApplicationArea = All;
                        Caption = 'Job WIP';
                        Image = WIP;
                        RunObject = Page "Job WIP Cockpit";
                        ToolTip = 'Overview and track work in process for all of your projects. Each line contains information about a job, including calculated and posted WIP.';
                    }
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = All;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                }
            }
        }
    }
}

