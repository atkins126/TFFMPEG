unit uTestMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uVideoMain, Vcl.Menus, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.DateUtils, uMediaDisplay;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    Open1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N1: TMenuItem;
    DecodePak1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    Memo3: TMemo;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    TabSheet2: TTabSheet;
    TrayIcon1: TTrayIcon;
    TaskDialog1: TTaskDialog;
    Play1: TMenuItem;
    EST1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure DecodePak1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EST1Click(Sender: TObject);
    procedure Play1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    procedure OnError(Sender:TObject; ErrorCode:Integer; MSG:string);
  public
    { Public declarations }
    Media:TMediaDecoder;
  end;

var
  Form1: TForm1;
  MediaDisplay:TMediaDisplay;

implementation

{$R *.dfm}

procedure TForm1.DecodePak1Click(Sender: TObject);
begin
  {i:=1;
  try
   repeat
    Inc(i);
   until (not tmp.ReadPaked)OR(i > 10000);
  except

  end;
  Memo2.Clear;
  tmp.DecodePakedFromFrame;
  Memo2.Lines.BeginUpdate;
  for I := 0 to TMP.VideoPacket.Count-1 do begin
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].stream_index='+IntToStr(TMP.VideoPacket.Items[i].stream_index));
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].size='+IntToStr(TMP.VideoPacket.Items[i].size));
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].flags='+IntToStr(TMP.VideoPacket.Items[i].flags));
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].pts='+IntToStr(TMP.VideoPacket.Items[i].pts));
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].dts='+IntToStr(TMP.VideoPacket.Items[i].dts));
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].duration='+IntToStr(TMP.VideoPacket.Items[i].duration));
    Memo2.Lines.Add('AVPacket.Items['+IntToStr(i)+'].pos='+IntToStr(TMP.VideoPacket.Items[i].pos));
    Memo2.Lines.Add('===========');
  end;
  Memo2.Lines.EndUpdate;
  Memo3.Clear;
  Memo3.Lines.BeginUpdate;
  for I := 0 to tmp.VideoFrame.Count-1 do begin
   for j := 0 to TMP.AVStream.Count-1 do begin
    if TMP.AVStream.Items[j].AVStream.index = TMP.CurrentVideoStream then begin
    Memo3.Lines.Add('Time: '+floatToStr(//UnixToDateTime(
      (
        TMP.VideoFrame.Items[i].pts * (
          TMP.AVStream.Items[j].AVStream^.time_base.num / TMP.AVStream.Items[j].AVStream^.time_base.den
        )
      ) (* Return Second *)
      *1000 (* return Milisecond *)
    )//)
    );
    Break;
    end;
   end;
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].key_frame='+IntToStr(TMP.VideoFrame.Items[i].key_frame));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].width='+IntToStr(TMP.VideoFrame.Items[i].width));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].height='+IntToStr(TMP.VideoFrame.Items[i].height));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].pts='+IntToStr(TMP.VideoFrame.Items[i].pts));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].pkt_pts='+IntToStr(TMP.VideoFrame.Items[i].pkt_pts));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].pkt_dts='+IntToStr(TMP.VideoFrame.Items[i].pkt_dts));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].pkt_pos='+IntToStr(TMP.VideoFrame.Items[i].pkt_pos));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].pkt_duration='+IntToStr(TMP.VideoFrame.Items[i].pkt_duration));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].coded_picture_number='+IntToStr(TMP.VideoFrame.Items[i].coded_picture_number));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].display_picture_number='+IntToStr(TMP.VideoFrame.Items[i].display_picture_number));
    Memo3.Lines.Add('AVFrame.Items['+IntToStr(i)+'].best_effort_timestamp='+IntToStr(TMP.VideoFrame.Items[i].best_effort_timestamp));
    Memo3.Lines.Add('===========');
  end;
  Memo3.Lines.EndUpdate;   *}
end;

procedure TForm1.EST1Click(Sender: TObject);
begin
  Media.ReadPacked;
  Media.DecodeVideo;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MediaDisplay:=TMediaDisplay.Create(TabSheet2);
  MediaDisplay.AutoInitSDL:=False;
  MediaDisplay.Parent:=TabSheet2;
  MediaDisplay.Align:=alClient;
  MediaDisplay.DeInitSDL;
end;

procedure TForm1.OnError(Sender: TObject; ErrorCode: Integer; MSG: string);
begin
 Memo3.Lines.Add(MSG);
end;

procedure TForm1.Open1Click(Sender: TObject);
var i:Integer;
begin
 if not OpenDialog1.Execute then Exit;
 if not Assigned(Media) then Media:=TMediaDecoder.Create
 else Media.CloseFile;
 Media.OpenFile(OpenDialog1.FileName);
 Media.Display:=MediaDisplay;
 Media.OnError:=OnError;
end;

procedure TForm1.Play1Click(Sender: TObject);
begin
  if not Assigned(Media) then exit;
  Media.Start;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Assigned(Media) then StatusBar1.Panels[0].Text:='[C]'+Media.GetCurrentTime;
  if Assigned(Media) then StatusBar1.Panels[1].Text:='[B]'+Media.GetBufferTime;
  //if Assigned(Media) then StatusBar1.Panels[1].Text:='[T]'+Media.GetBufferTime;
end;

end.
