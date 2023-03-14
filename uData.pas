unit uData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.DialogService, FMX.Platform
{$IFDEF ANDROID}
    , Androidapi.JNI.Widget, Androidapi.Helpers
{$ENDIF};

type
  TfrmData = class(TForm)
    btnBack: TButton;
    memLog: TMemo;
    pnlBox: TPanel;
    lblNombreArchivo: TLabel;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
   // procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowMessageToast(const pMsg: String; pDuration: Integer);
    //function AppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;

  end;

var
  frmData: TfrmData;
  CloseOk: Boolean;
  MemoOriginal: string;
  FileRute: String;

implementation

{$R *.fmx}

uses System.IOUtils, uMain;

 //var
 //AppEventSvc: IFMXApplicationEventService;

procedure TfrmData.ShowMessageToast(const pMsg: String; pDuration: Integer);
begin
{$IFDEF ANDROID}
  TThread.Synchronize(nil,
    procedure
    begin
      TJToast.JavaClass.makeText(TAndroidHelper.Context,
        StrToJCharSequence(pMsg), pDuration).show
    end);
{$ENDIF}
end;

procedure TfrmData.btnBackClick(Sender: TObject); // btnBack
begin
  Close;
end; // end btnBack

procedure TfrmData.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
// CloseQuery

var
  msg: string;

begin

  if (MemoOriginal <> memLog.Text) then
  begin

    msg := ' El archivo fue "MODIFICADO" ¿Desea guardar los cambios antes de salir?';
    TDialogService.MessageDialog(msg // mensaje del dialogo
      , TMsgDlgType.mtConfirmation // tipo de dialogo
      , [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel] // botones
      , TMsgDlgBtn.mbNo // default button
      , 0 // help context
      ,
      procedure(const AResult: TModalResult)
      begin
        case AResult of

          mrYES:
            begin
              CloseOk := True;

              memLog.Lines.SaveToFile(FileRute);
              MemoOriginal := memLog.Text;

{$IFDEF ANDROID}
              Close;

{$ENDIF}
            end;
          mrNO:
            begin
              CloseOk := True;
              MemoOriginal := memLog.Text;

{$IFDEF ANDROID}
              Close;
{$ENDIF}
            end;
        end;

      end);

  end
  else
    CloseOk := True;

  CanClose := CloseOk;

end; // end CloseQuery

{procedure TfrmData.FormCreate(Sender: TObject);
var
 AppEventSvc: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
  begin
    AppEventSvc.SetApplicationEventHandler(AppEvent);
  end;

end;   }


{function TfrmData.AppEvent(AAppEvent: TApplicationEvent;
AContext: TObject): Boolean;
begin
  var
  t := AAppEvent;
  case AAppEvent of

    TApplicationEvent.WillTerminate:

      Begin
        frmData.memLog.Lines.add
          ('El sistema operativo se ha apagado');
        frmData.memLog.Lines.SaveToFile(TPath.Combine(ruta, ValuesText));
      End;
  end;
  Result := True;
end;  }

procedure TfrmData.FormShow(Sender: TObject);
begin

  FileRute := TPath.Combine(uMain.ruta, uMain.ValuesText);
  // se establece la ruta del archivo
  // en una sola variable
  if fileexists(FileRute) then
  begin
    memLog.Lines.LoadFromFile(FileRute);
    MemoOriginal := memLog.Text;

  end
  else
    memLog.Lines.Clear;

  lblNombreArchivo.Text := 'Archivo: ' + uMain.ValuesText;
  CloseOk := false;

end;

end.
