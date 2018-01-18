type vbCodeJob
    as string formName
    as string className
    as string eventName
    as integer cnt
    as integer ff
    
    declare constructor()
    declare constructor(formName as string, className as string, eventName as string, cnt as integer)
    declare sub set(formName as string, className as string, eventName as string, cnt as integer)
    declare sub writeSub(text as string)
    declare sub writeLine(text as string)
    declare sub writeUnknown(id as integer)
    declare sub writeEndSub()
    declare sub generate(ff as integer, id as integer)
end type

constructor vbCodeJob()
    'Hello
end constructor

constructor vbCodeJob(formName as string, className as string, eventName as string, cnt as integer)
    this.set(formName, className, eventName, cnt)
end constructor

sub vbCodeJob.set(formName as string, className as string, eventName as string, cnt as integer)
    this.formName = formName
    this.className = className
    this.eventName = eventName
    this.cnt = cnt
end sub

sub vbCodeJob.writeSub(text as string)
    print #this.ff,text
    this.writeEndSub()
end sub

sub vbCodeJob.writeLine(text as string)
    print #this.ff,text
end sub

sub vbCodeJob.writeUnknown(id as integer)
    writeLine("Unknown: form=" & this.formName & ", class=" & this.className & ", event=" & this.eventName & ", ID=" & id)
end sub

sub vbCodeJob.writeEndSub()
    this.writeLine("    End Sub")
    this.writeLine("    ")
end sub

sub vbCodeJob.generate(ff as integer, id as integer)
    this.ff = ff
    select case ucase(this.className)
    case "FORM"
        select case ucase(this.eventName)
        case "INIT"
            this.writeSub("    Private Sub " & this.formName & "_Load(sender As Object, e As EventArgs) Handles MyBase.Load")
        case else
            this.writeUnknown(id)
        end select
    case "LABEL"
        select case ucase(this.eventName)
        case "CLICK"
            this.writeSub("    Private Sub Label" & id & "_Click(sender As Object, e As EventArgs) Handles Label" & id & ".Click")
        case "DBLCLICK"
            this.writeSub("    Private Sub Label" & id & "_DoubleClick(sender As Object, e As EventArgs) Handles Label" & id & ".DoubleClick")
        case else
            this.writeUnknown(id)
        end select
    case "COMMANDBUTTON"
        select case ucase(this.eventName)
        case "CLICK"
            this.writeSub("    Private Sub Button" & id & "_Click(sender As Object, e As EventArgs) Handles Button" & id & ".Click")
        case else
            this.writeUnknown(id)
        end select
    case else
        this.writeUnknown(id)
    end select
end sub
