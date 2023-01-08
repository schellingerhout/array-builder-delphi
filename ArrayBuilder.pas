unit ArrayBuilder;

interface

Type

  TGrowthFunction = reference to function(CurrentSize: Integer): Integer;

  TArrayBuilder<T> = Record
  private
    FData: TArray<T>;
    FCount: Integer;
    FGrowthFunction: TGrowthFunction;
  public
    class function Init(Size: Integer): TArrayBuilder<T>; static;

    // Record Initializers added in Delphi 10.4
    class operator Initialize(out Dest: TArrayBuilder<T>);

    procedure Add(const Element: T);
    function GetArray: TArray<T>;
    procedure SetGrowthFunction(const F: TGrowthFunction);
  end;

  // due to the way Generics resolve I have to make the default growth function public
  function DefaultArrayBuilderGrowthFunction(Size: integer): integer;

implementation

function DefaultArrayBuilderGrowthFunction(Size: integer): integer;
begin
  if size = 0 then
    exit(4);

  if size < 5 then
    exit(8);

  if size < 9 then
    exit(16);

  result := (Size * 3) div 2;
end;


class operator TArrayBuilder<T>.Initialize(out Dest: TArrayBuilder<T>);
const
  DefaultRec: TArrayBuilder<T> = (); // count = 0, dynamic array empty
begin
  Dest := DefaultRec;
  Dest.FGrowthFunction := DefaultArrayBuilderGrowthFunction;
end;

procedure TArrayBuilder<T>.SetGrowthFunction(const F: TGrowthFunction);
begin
  FGrowthFunction := F;
end;

class function TArrayBuilder<T>.Init(Size: Integer): TArrayBuilder<T>;
begin
  SetLength(Result.FData, Size);
end;

procedure TArrayBuilder<T>.Add(const Element: T);
begin
  if FCount > High(FData) then
     SetLength(FData, FGrowthFunction(Length(FData)));

  FData[FCount] := Element;
  Inc(FCount);
end;

function TArrayBuilder<T>.GetArray: TArray<T>;
begin
  SetLength(FData, FCount);
  Result := FData;
end;

end.
