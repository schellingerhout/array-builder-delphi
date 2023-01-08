type

unit ArrayBuilder;
interface
Type

TGrowthFunction = reference to function(CurrentSize: Integer): Integer;

TArrayBuilder<T> = Record
private
  Data: TArray<T>;
  Count: Integer;
  GrowthFunction: TGrowthFunction;
public
  class function Init(Size: integer): TArrayBuilder<T>; static;  

  // Record Initializers added in Delphi 10.4
  class operator Initialize (out Dest: TArrayBuilder<T>);   

  procedure Add(const Element: T);
  procedure SetGrowthFunction(const F: TGrowthFunction);
  function GetArray: TArray<T>;
end;

implementation

// default growth function... possible extensions can pass a reference to a function like this
function NextSize(Size: integer): integer; 
begin
  if size = 0 then
    exit(4);
    
  if size < 5 then
    exit(8);

  if size < 9 then
    exit(16);

  result := (Size * 3) div 2)
end;


class operator TArrayBuilder<T>.Initialize(out Dest: TArrayBuilder<T>);
const
  DefaultRec : TArrayBuilder<T> = (); //count = 0, dynamic array empty
begin
  Dest := DefaultRec;
  Dest.GrowthFunction := NextSize;
end;

class function TArrayBuilder<T>.Init(Size: integer): TArrayBuilder<T>; static;
begin
  Count := 0;
  SetLength(Data, Size);  
end;


procedure TArrayBuilder<T>.Add(const Element: T);
begin
  if Count > High(Data) then
     SetLength(Data, GrowthFunction(Length(Data)) );

  Data[Count] := Element;
  Inc(Count);
end;


function TArrayBuilder<T>.GetArray: TArray<T>;
begin
  SetLength(Data, Count);
  Result := Data;
end;
