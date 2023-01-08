unit ArrayBuilder;

interface

Type

  TArrayBuilder<T> = Record
  private
    FData: TArray<T>;
    FCount: Integer;

    procedure Grow;
  public
    class function Init(Size: Integer): TArrayBuilder<T>; static;

    // Record Initializers added in Delphi 10.4
    class operator Initialize(out Dest: TArrayBuilder<T>);

    procedure Add(const Element: T);
    function GetArray: TArray<T>;
  end;

implementation

class operator TArrayBuilder<T>.Initialize(out Dest: TArrayBuilder<T>);
const
  DefaultRec: TArrayBuilder<T> = (); // count = 0, dynamic array empty
begin
  Dest := DefaultRec;
end;

class function TArrayBuilder<T>.Init(Size: Integer): TArrayBuilder<T>;
begin
  SetLength(Result.FData, Size);
end;

procedure TArrayBuilder<T>.Add(const Element: T);
begin
  if FCount > High(FData) then
    Grow;

  FData[FCount] := Element;
  Inc(FCount);
end;

procedure TArrayBuilder<T>.Grow;
var
  NewSize: Integer;
begin

  if FData = nil then
    NewSize := 4
  else if Length(FData) < 5 then
    NewSize := 8
  else if Length(FData) < 9 then
    NewSize := 16
  else
    NewSize := (Length(FData) * 3) div 2;

  SetLength(FData, NewSize);
end;

function TArrayBuilder<T>.GetArray: TArray<T>;
begin
  SetLength(FData, FCount);
  Result := FData;
end;

end.
