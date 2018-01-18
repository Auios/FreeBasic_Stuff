#include "crt.bi"
#include "vbCodeJob.bas"

type vbFile
    'Base
    as boolean isOpen
    as string fileName
    as integer ff
    as integer tabIndex
    as integer jobCount
    as vbCodeJob ptr job
    
    'Entity count
    as integer nLabels
    as integer nButtons
    
    'Constructors/Destructors
    declare constructor()
    declare constructor(fileName as string)
    declare destructor()
    
    'Generation
    declare sub generate()
    declare sub generateDesign()
    declare sub generateEvents()
    declare sub generateResx()
    
    'Phases
    declare sub phase1()
    declare sub phase2()
    declare sub phase3()
    declare sub phase4()
    
    'Job management
    declare sub addJob(form as string, class as string, event as string, cnt as integer)
    
    'Open/Close
    declare sub fOpen(ext as string)
    declare sub fClose()
    
    'Writers
    declare sub writeLine(text as string)
    declare sub writeHeader()
    declare sub addFormHeader()
    declare sub addFormFooter()
    
    'Other
    declare sub printError(e as string, a as string = "")
    declare sub resetSelf()
end type

'==================
'==================Constructors/Destructors
'==================

constructor vbFile()
    'No my work is not done yet... :(
end constructor

constructor vbFile(fileName as string)
    this.fileName = fileName
end constructor

destructor vbFile()
    delete[] this.job
    this.job = 0
end destructor

'==================
'==================Generation
'==================

sub vbFile.generate()
    this.fOpen(".Designer.vb")
    this.generateDesign()
    this.fClose()
    
    this.fOpen(".vb")
    this.generateEvents()
    this.fClose()
    
    this.fOpen(".resx")
    this.generateResx()
    this.fClose()
end sub

sub vbFile.generateDesign()
    if(NOT this.isOpen) then this.printError("vbFormFile is not open!", "generate()"):sleep():end(1)
    
    if(this.jobCount) then
        for i as integer = 0 to this.jobCount-1
            select case ucase(this.job[i].className)
            case "LABEL"
                this.nLabels+=this.job[i].cnt
            case "COMMANDBUTTON"
                this.nButtons+=this.job[i].cnt
            end select
        next i
    end if
    
    print this.nButtons
    
    this.writeHeader()
    this.phase1()
    this.writeLine(!"        Me.SuspendLayout()")
    this.phase2()
    this.addFormHeader()
    this.phase3()
    this.addFormFooter()
    this.writeLine(!"")
    this.writeLine(!"    End Sub")
    this.writeLine(!"")
    this.phase4()
    this.writeLine(!"End Class")
end sub

sub vbFile.generateEvents()
    if(NOT this.isOpen) then this.printError("vbFormFile is not open!", "generate()"):sleep():end(1)
    this.writeLine("Public Class " & this.fileName)
    if(this.jobCount) then
        for i as integer = 0 to this.jobCount-1
            for j as integer = 1 to this.job[i].cnt
                this.job[i].generate(this.ff, j)
            next j
        next i
    end if
    this.writeLine("End Class")
end sub

sub vbFile.generateResx()
    this.writeLine(!"<?xml version=\"1.0\" encoding=\"utf-8\"?>")
    this.writeLine(!"<root>")
    this.writeLine(!"  <!-- ")
    this.writeLine(!"    Microsoft ResX Schema ")
    this.writeLine(!"    ")
    this.writeLine(!"    Version 2.0")
    this.writeLine(!"    ")
    this.writeLine(!"    The primary goals of this format is to allow a simple XML format ")
    this.writeLine(!"    that is mostly human readable. The generation and parsing of the ")
    this.writeLine(!"    various data types are done through the TypeConverter classes ")
    this.writeLine(!"    associated with the data types.")
    this.writeLine(!"    ")
    this.writeLine(!"    Example:")
    this.writeLine(!"    ")
    this.writeLine(!"    ... ado.net/XML headers & schema ...")
    this.writeLine(!"    <resheader name=\"resmimetype\">text/microsoft-resx</resheader>")
    this.writeLine(!"    <resheader name=\"version\">2.0</resheader>")
    this.writeLine(!"    <resheader name=\"reader\">System.Resources.ResXResourceReader, System.Windows.Forms, ...</resheader>")
    this.writeLine(!"    <resheader name=\"writer\">System.Resources.ResXResourceWriter, System.Windows.Forms, ...</resheader>")
    this.writeLine(!"    <data name=\"Name1\"><value>this is my long string</value><comment>this is a comment</comment></data>")
    this.writeLine(!"    <data name=\"Color1\" type=\"System.Drawing.Color, System.Drawing\">Blue</data>")
    this.writeLine(!"    <data name=\"Bitmap1\" mimetype=\"application/x-microsoft.net.object.binary.base64\">")
    this.writeLine(!"        <value>[base64 mime encoded serialized .NET Framework object]</value>")
    this.writeLine(!"    </data>")
    this.writeLine(!"    <data name=\"Icon1\" type=\"System.Drawing.Icon, System.Drawing\" mimetype=\"application/x-microsoft.net.object.bytearray.base64\">")
    this.writeLine(!"        <value>[base64 mime encoded string representing a byte array form of the .NET Framework object]</value>")
    this.writeLine(!"        <comment>This is a comment</comment>")
    this.writeLine(!"    </data>")
    this.writeLine(!"                ")
    this.writeLine(!"    There are any number of \"resheader\" rows that contain simple ")
    this.writeLine(!"    name/value pairs.")
    this.writeLine(!"    ")
    this.writeLine(!"    Each data row contains a name, and value. The row also contains a ")
    this.writeLine(!"    type or mimetype. Type corresponds to a .NET class that support ")
    this.writeLine(!"    text/value conversion through the TypeConverter architecture. ")
    this.writeLine(!"    Classes that don't support this are serialized and stored with the ")
    this.writeLine(!"    mimetype set.")
    this.writeLine(!"    ")
    this.writeLine(!"    The mimetype is used for serialized objects, and tells the ")
    this.writeLine(!"    ResXResourceReader how to depersist the object. This is currently not ")
    this.writeLine(!"    extensible. For a given mimetype the value must be set accordingly:")
    this.writeLine(!"    ")
    this.writeLine(!"    Note - application/x-microsoft.net.object.binary.base64 is the format ")
    this.writeLine(!"    that the ResXResourceWriter will generate, however the reader can ")
    this.writeLine(!"    read any of the formats listed below.")
    this.writeLine(!"    ")
    this.writeLine(!"    mimetype: application/x-microsoft.net.object.binary.base64")
    this.writeLine(!"    value   : The object must be serialized with ")
    this.writeLine(!"            : System.Runtime.Serialization.Formatters.Binary.BinaryFormatter")
    this.writeLine(!"            : and then encoded with base64 encoding.")
    this.writeLine(!"    ")
    this.writeLine(!"    mimetype: application/x-microsoft.net.object.soap.base64")
    this.writeLine(!"    value   : The object must be serialized with ")
    this.writeLine(!"            : System.Runtime.Serialization.Formatters.Soap.SoapFormatter")
    this.writeLine(!"            : and then encoded with base64 encoding.")
    this.writeLine(!"")
    this.writeLine(!"    mimetype: application/x-microsoft.net.object.bytearray.base64")
    this.writeLine(!"    value   : The object must be serialized into a byte array ")
    this.writeLine(!"            : using a System.ComponentModel.TypeConverter")
    this.writeLine(!"            : and then encoded with base64 encoding.")
    this.writeLine(!"    -->")
    this.writeLine(!"  <xsd:schema id=\"root\" xmlns=\"\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\">")
    this.writeLine(!"    <xsd:import namespace=\"http://www.w3.org/XML/1998/namespace\" />")
    this.writeLine(!"    <xsd:element name=\"root\" msdata:IsDataSet=\"true\">")
    this.writeLine(!"      <xsd:complexType>")
    this.writeLine(!"        <xsd:choice maxOccurs=\"unbounded\">")
    this.writeLine(!"          <xsd:element name=\"metadata\">")
    this.writeLine(!"            <xsd:complexType>")
    this.writeLine(!"              <xsd:sequence>")
    this.writeLine(!"                <xsd:element name=\"value\" type=\"xsd:string\" minOccurs=\"0\" />")
    this.writeLine(!"              </xsd:sequence>")
    this.writeLine(!"              <xsd:attribute name=\"name\" use=\"required\" type=\"xsd:string\" />")
    this.writeLine(!"              <xsd:attribute name=\"type\" type=\"xsd:string\" />")
    this.writeLine(!"              <xsd:attribute name=\"mimetype\" type=\"xsd:string\" />")
    this.writeLine(!"              <xsd:attribute ref=\"xml:space\" />")
    this.writeLine(!"            </xsd:complexType>")
    this.writeLine(!"          </xsd:element>")
    this.writeLine(!"          <xsd:element name=\"assembly\">")
    this.writeLine(!"            <xsd:complexType>")
    this.writeLine(!"              <xsd:attribute name=\"alias\" type=\"xsd:string\" />")
    this.writeLine(!"              <xsd:attribute name=\"name\" type=\"xsd:string\" />")
    this.writeLine(!"            </xsd:complexType>")
    this.writeLine(!"          </xsd:element>")
    this.writeLine(!"          <xsd:element name=\"data\">")
    this.writeLine(!"            <xsd:complexType>")
    this.writeLine(!"              <xsd:sequence>")
    this.writeLine(!"                <xsd:element name=\"value\" type=\"xsd:string\" minOccurs=\"0\" msdata:Ordinal=\"1\" />")
    this.writeLine(!"                <xsd:element name=\"comment\" type=\"xsd:string\" minOccurs=\"0\" msdata:Ordinal=\"2\" />")
    this.writeLine(!"              </xsd:sequence>")
    this.writeLine(!"              <xsd:attribute name=\"name\" type=\"xsd:string\" use=\"required\" msdata:Ordinal=\"1\" />")
    this.writeLine(!"              <xsd:attribute name=\"type\" type=\"xsd:string\" msdata:Ordinal=\"3\" />")
    this.writeLine(!"              <xsd:attribute name=\"mimetype\" type=\"xsd:string\" msdata:Ordinal=\"4\" />")
    this.writeLine(!"              <xsd:attribute ref=\"xml:space\" />")
    this.writeLine(!"            </xsd:complexType>")
    this.writeLine(!"          </xsd:element>")
    this.writeLine(!"          <xsd:element name=\"resheader\">")
    this.writeLine(!"            <xsd:complexType>")
    this.writeLine(!"              <xsd:sequence>")
    this.writeLine(!"                <xsd:element name=\"value\" type=\"xsd:string\" minOccurs=\"0\" msdata:Ordinal=\"1\" />")
    this.writeLine(!"              </xsd:sequence>")
    this.writeLine(!"              <xsd:attribute name=\"name\" type=\"xsd:string\" use=\"required\" />")
    this.writeLine(!"            </xsd:complexType>")
    this.writeLine(!"          </xsd:element>")
    this.writeLine(!"        </xsd:choice>")
    this.writeLine(!"      </xsd:complexType>")
    this.writeLine(!"    </xsd:element>")
    this.writeLine(!"  </xsd:schema>")
    this.writeLine(!"  <resheader name=\"resmimetype\">")
    this.writeLine(!"    <value>text/microsoft-resx</value>")
    this.writeLine(!"  </resheader>")
    this.writeLine(!"  <resheader name=\"version\">")
    this.writeLine(!"    <value>2.0</value>")
    this.writeLine(!"  </resheader>")
    this.writeLine(!"  <resheader name=\"reader\">")
    this.writeLine(!"    <value>System.Resources.ResXResourceReader, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>")
    this.writeLine(!"  </resheader>")
    this.writeLine(!"  <resheader name=\"writer\">")
    this.writeLine(!"    <value>System.Resources.ResXResourceWriter, System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089</value>")
    this.writeLine(!"  </resheader>")
    this.writeLine(!"</root>")
end sub
'==================
'==================Phases
'==================

sub vbFile.phase1()
    if(this.nLabels) then
        for i as integer = 1 to this.nLabels
            this.writeLine(!"        Me.Label" & i & !" = New System.Windows.Forms.Label()")
        next i
    end if
    
    if(this.nButtons) then
        for i as integer = 1 to this.nButtons
            this.writeLine(!"        Me.Button" & i & !" = New System.Windows.Forms.Button()")
        next i
    end if
end sub

sub vbFile.phase2()
    'Labels
    if(this.nLabels) then
        for i as integer = 1 to this.nLabels
            this.writeline(!"        '")
            this.writeline(!"        'Label" & i)
            this.writeline(!"        '")
            this.writeline(!"        Me.Label" & i & !".AutoSize = True")
            this.writeline(!"        Me.Label" & i & !".Location = New System.Drawing.Point(0, 0)")
            this.writeline(!"        Me.Label" & i & !".Name = \"Label" & i & !"\"")
            this.writeline(!"        Me.Label" & i & !".Size = New System.Drawing.Size(0, 0)")
            this.writeline(!"        Me.Label" & i & !".TabIndex = " & this.tabIndex)
            this.writeline(!"        Me.Label" & i & !".Text = \"Label" & i & !"\"")
            this.tabIndex+=1
        next i
    end if
    
    'Buttons
    if(this.nButtons) then
        for i as integer = 1 to this.nButtons
            this.writeline(!"        '")
            this.writeline(!"        'Button" & i)
            this.writeline(!"        '")
            this.writeline(!"        Me.Button" & i & !".Location = New System.Drawing.Point(0, 0)")
            this.writeline(!"        Me.Button" & i & !".Name = \"Button" & i & !"\"")
            this.writeline(!"        Me.Button" & i & !".Size = New System.Drawing.Size(0, 0)")
            this.writeline(!"        Me.Button" & i & !".TabIndex = " & this.tabIndex)
            this.writeline(!"        Me.Button" & i & !".Text = \"Button" & i & !"\"")
            this.writeline(!"        Me.Button" & i & !".UseVisualStyleBackColor = True")
            this.tabIndex+=1
        next i
    end if
end sub

sub vbFile.phase3()
    if(this.nButtons) then
        for i as integer = nButtons to 1 step -1
            this.writeLine("        Me.Controls.Add(Me.Button" & i & ")")
        next i
    end if
    
    if(this.nLabels) then
        for i as integer = nLabels to 1 step -1
            this.writeLine("        Me.Controls.Add(Me.Label" & i & ")")
        next i
    end if
end sub

sub vbFile.phase4()
    if(this.nLabels) then
        for i as integer = 1 to nLabels
            this.writeLine("    Friend WithEvents Label" & i & " As Label")
        next i
    end if
    
    if(this.nButtons) then
        for i as integer = 1 to nButtons
            this.writeLine("    Friend WithEvents Button" & i & " As Button")
        next i
    end if
end sub

'==================
'==================Job management
'==================

sub vbFile.addJob(form as string, className as string, event as string, cnt as integer)
    dim as vbCodeJob ptr tempJob
    if(this.jobCount) then
        if(this.jobCount = 1) then
            this.jobCount+=1
            tempJob = this.job
            this.job = new vbCodeJob[this.jobCount]
            this.job[0] = tempJob[0]
            this.job[1].set(form, className, event, cnt)
            delete[] tempJob
        else
            this.jobCount+=1
            tempJob = new vbCodeJob[this.jobCount]
            for i as integer = 0 to this.jobCount-2
                tempJob[i] = this.job[i]
            next i
            tempJob[this.jobCount-1].set(form, className, event, cnt)
            delete[] this.job
            this.job = tempJob
        end if
    else
        this.jobCount+=1
        this.job = new vbCodeJob[this.jobCount]
        this.job[0].set(form, className, event, cnt)
    end if
end sub

'==================
'==================Open/Close
'==================

sub vbFile.fOpen(ext as string)
    if(this.isOpen) then this.printError("vbFile object already has a file open!", "fOpenDesign()"):sleep():end(1)
    this.ff = freeFile()
    this.fileName = fileName
    open "Output\" & this.fileName & ext for output as #this.ff
    this.isOpen = true
end sub

sub vbFile.fClose()
    if(this.isOpen) then
        close #this.ff
        this.isOpen = false
    else
        this.printError("vbFile trying to close nothing!", "fClose()"):sleep()
    end if
end sub

'==================
'==================Writers
'==================

sub vbFile.writeLine(text as string)
    if(NOT this.isOpen) then this.printError("vbFormFile is not open!", "writeLine()"):sleep():end(1)
    print #this.ff,text
end sub

sub vbFile.writeHeader()
    if(NOT this.isOpen) then this.printError("vbFormFile is not open!", "writeHeader()"):sleep():end(1)
    this.writeLine(!"<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _")
    this.writeLine(!"Partial Class " & this.fileName)
    this.writeLine(!"    Inherits System.Windows.Forms.Form")
    this.writeLine(!"    ")
    this.writeLine(!"    'Form overrides dispose to clean up the component list.")
    this.writeLine(!"    <System.Diagnostics.DebuggerNonUserCode()> _")
    this.writeLine(!"    Protected Overrides Sub Dispose(ByVal disposing As Boolean)")
    this.writeLine(!"        Try")
    this.writeLine(!"            If disposing AndAlso components IsNot Nothing Then")
    this.writeLine(!"                components.Dispose()")
    this.writeLine(!"            End If")
    this.writeLine(!"        Finally")
    this.writeLine(!"            MyBase.Dispose(disposing)")
    this.writeLine(!"        End Try")
    this.writeLine(!"    End Sub")
    this.writeLine(!"    ")
    this.writeLine(!"    'Required by the Windows Form Designer")
    this.writeLine(!"    Private components As System.ComponentModel.IContainer")
    this.writeLine(!"    ")
    this.writeLine(!"    'NOTE: The following procedure is required by the Windows Form Designer")
    this.writeLine(!"    'It can be modified using the Windows Form Designer.")
    this.writeLine(!"    'Do not modify it using the code editor.")
    this.writeLine(!"    <System.Diagnostics.DebuggerStepThrough()> _")
    this.writeLine(!"    Private Sub InitializeComponent()")
end sub

sub vbFile.addFormHeader()
    if(NOT this.isOpen) then this.printError("vbFormFile is not open!", "addFormHeader()"):sleep():end(1)
    this.writeLine(!"        '")
    this.writeLine(!"        '" & this.fileName)
    this.writeLine(!"        '")
    this.writeLine(!"        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)")
    this.writeLine(!"        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font")
    this.writeLine(!"        Me.ClientSize = New System.Drawing.Size(480, 360)")
end sub

sub vbFile.addFormFooter()
    if(NOT this.isOpen) then this.printError("vbFormFile is not open!", "addFormFooter()"):sleep():end(1)
    this.writeLine(!"        Me.Name = \"" & this.fileName & !"\"")
    this.writeLine(!"        Me.Text = \"" & this.fileName & !"\"")
    this.writeLine(!"        Me.ResumeLayout(False)")
    this.writeLine(!"        Me.PerformLayout()")
end sub

'==================
'==================Other
'==================

sub vbFile.printError(e as string, a as string = "")
    dim as string finalMessage = "ERROR: " + e
    if(len(a)) then
        finalMessage+=" [" & a & "]"
    end if
    finalMessage+=!"\n"
    printf(finalMessage)
end sub

sub vbFile.resetSelf()
    this = vbFile
end sub