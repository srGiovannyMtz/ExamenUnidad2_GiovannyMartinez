{ Angel Giovanny Martinez Soto Nc: 19940214 8AS

  T2.6 Diálogos entre forms.
  Realizar la práctica siguiendo los pasos del documento anexo a este documento.
  Esta tarea consiste en lanzar una ventana para editar un texto, ese texto se va guardando
  en un archivo, si el usuario se sale de esa ventana, hay que preguntar si desea guardar los
  cambios, en el caso de que los cambios se guarden, estos se deben guardar fìsicamente en el
  dispositivo, para que el archivo pueda ser cargado en el futuro. Si el usuario no hace cambios,
  entonces "no es necesario mostrar el diàlogo, puesto que no hubo cambios".

  Nota: debe tener cuidado de intentar abrir un archivo que no existe, si este archivo no existe
  y lo intenta abrir, la app lanzará una excepción. Para evitar esto, hay que usar las funciones
  de verficación correspondientes.


  if modificado = true and close = false
  if (modificado and not close )
  if (modificado)



  onCreate
  onShow
  onActivate
  onDesactive
  onDestroy
}

unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.DialogService, FMX.Platform;

type
  TfrmMain = class(TForm)
    lblMain: TLabel;
    btnShowFrmDatos: TButton;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnShowFrmDatosClick(Sender: TObject);
    procedure btnInputQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }


  end;

var
  frmMain: TfrmMain;
  ValuesText: String;
  bandera: Boolean = false;
  msg: string;
  fichero: TPersistent;
  ruta: string;

implementation

{$R *.fmx}

uses

  System.IOUtils,
  uData;
 //var
 //AppEventSvc: IFMXApplicationEventService;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnShowFrmDatosClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS OR MACOS}
  // Windows specific code here
  frmData.ShowModal;
{$ELSE}
  // Android/iOS specific code here
  frmData.Show;
{$ENDIF}
end;

procedure TfrmMain.FormCreate(Sender: TObject); // FormCreate
begin

  // crea la ruta dependiendo el SO
{$IF DEFINED(MSWINDOWS)}
  // windows
  ruta := '';
{$ELSEIF DEFINED(ANDROID)}
  // Android-specific code here

  ruta := TPath.GetDownloadsPath;
{$ENDIF}


end; // end FormCreate





procedure TfrmMain.btnInputQueryClick(Sender: TObject);
var

  valuesTextDefault: String; // variable para almacenar el texto por defecto
begin

  valuesTextDefault := 'NombreDelArchivo.txt';
  TDialogService.InputQuery('Abrir Archivo' // titulo del dialogo
    , ['Nombre:'] // labels
    , valuesTextDefault // valores con valor inicial por defecto
    ,
    procedure(const AResult: TModalResult; const AValues: array of string)

    begin

      if AResult = mrOK then
      begin

        ValuesText := AValues[0];

        if FileExists(TPath.Combine(ruta, ValuesText)) = false then
        begin
          msg := ' El archivo no existe, ¿Desea Crearlo?';
          TDialogService.MessageDialog(msg // mensaje del dialogo
            , TMsgDlgType.mtConfirmation // tipo de dialogo
            , [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo]
            // botones
            , TMsgDlgBtn.mbNo // default button
            , 0 // help context
            ,
            procedure(const AResult: TModalResult)

            begin
              if AResult = mrYES then
              begin
{$IFDEF MSWINDOWS OR MACOS}
                // Windows specific code here
                frmData.ShowModal;
{$ELSE}
                // Android/iOS specific code here
                frmData.Show;
{$ENDIF}
              end;

            end);

        end
        else
        begin

{$IFDEF MSWINDOWS OR MACOS}
          // Windows specific code here
          frmData.ShowModal;
{$ELSE}
          // Android/iOS specific code here
          frmData.Show;
{$ENDIF}
        end;

      end;

    end);

end;

end.
