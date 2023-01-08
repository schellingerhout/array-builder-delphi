# array-builder-delphi
Generic Builder for Dynamic Arrays in Delphi


Sample use:

```pascal

function PrimesBelow(MaxValue: integer): TArray<Integer>;
var
  Prime: integer;
  PrimeBuilder: TArrayBuilder<Integer>;
begin
  Prime := 2;
  while Prime < MaxValue do
  begin
    PrimeBuilder.Add(Prime)  
    Prime := NextPrime(Prime); // implementation not shown
  end;   

  result := PrimeBuilder.GetArray;
end;

```


The growth function that grows linearly can be set also. For instance to grow linearly in blocks of 100

```pascal
...
  PrimeBuilder.SetGrowthFunction(function (Size: integer): integer
    begin
      result := Size + 100;
    end
  );
 ...
 ```

