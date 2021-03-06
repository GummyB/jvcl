{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDataEmbedded.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse@buypin.com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2000-02-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$I JEDI.INC}

unit JvDataEmbedded;

{$OBJEXPORTALL On}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Dialogs, JvComponent;

type
  TJvDataEmbedded = class(TJvComponent)
  private
    FStream: TMemoryStream;
    function GetSize: Integer;
    procedure WriteData(Stream: TStream);
    procedure ReadData(Stream: TStream);
    function GetStream: TStream;
    procedure SetStream(const Value: TStream);
    procedure SetSize(const Value: Integer);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SaveToFile(FileName: TFileName);
    procedure SaveToStream(Stream: TStream);
  published
    property Size: Integer read GetSize write SetSize;
    property Data: TStream read GetStream write SetStream;
  end;

implementation

{**************************************************}

constructor TJvDataEmbedded.Create(AOwner: TComponent);
begin
  inherited;
  FStream := TMemoryStream.Create;
end;

{**************************************************}

procedure TJvDataEmbedded.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('EmbeddedData', ReadData, WriteData,
    FStream.Size > 0);
end;

{**************************************************}

destructor TJvDataEmbedded.Destroy;
begin
  FStream.Free;
  inherited;
end;

{**************************************************}

function TJvDataEmbedded.GetSize: Integer;
begin
  Result := FStream.Size;
end;

{**************************************************}

function TJvDataEmbedded.GetStream: TStream;
begin
  Result := TMemoryStream.Create;
  Result.CopyFrom(FStream, 0);
  Result.Position := 0;
end;

{**************************************************}

procedure TJvDataEmbedded.ReadData(Stream: TStream);
var
  i: Integer;
begin
  Stream.Read(i, SizeOf(i));
  FStream.Clear;
  FStream.Size := i;
  Stream.Read(FStream.Memory^, i);
end;

{**************************************************}

procedure TJvDataEmbedded.SaveToFile(FileName: TFileName);
begin
  FStream.SaveToFile(FileName);
end;

{**************************************************}

procedure TJvDataEmbedded.SaveToStream(Stream: TStream);
begin
  Stream.CopyFrom(FStream, 0);
end;

{**************************************************}

procedure TJvDataEmbedded.SetSize(const Value: Integer);
begin
  FStream.SetSize(Value);
end;

{**************************************************}

procedure TJvDataEmbedded.SetStream(const Value: TStream);
begin
  FStream.Clear;
  if Value <> nil then
    FStream.CopyFrom(Value, Value.Size - Value.Position);
end;

{**************************************************}

procedure TJvDataEmbedded.WriteData(Stream: TStream);
var
  i: Integer;
begin
  i := FStream.Size;
  Stream.Write(i, SizeOf(i));
  Stream.Write(FStream.Memory^, i);
end;

end.
