function viagrid;
var
  Board : IPCB_Board;
  Iter : IPCB_BoardIterator;
  Via : IPCB_Via;
  grid, x, y : double;
begin
  Board := PCBServer.GetCurrentPCBBoard;
  If Board = Nil then exit;
  ResetParameters;
  AddStringParameter('Scope','All');
  RunProcess('PCB:DeSelect');
  Iter := Board.BoardIterator_Create;
  Iter.AddFilter_ObjectSet(MkSet(eViaObject));
  Iter.AddFilter_AllLayers;
  Via := Iter.FirstPCBObject;
  While (Via <> nil) do begin
    x := roundto(coordtomms(Via.x-Board.BoardOutline.BoundingRectangle.Left),-3);
    y := roundto(coordtomms(Via.y-Board.BoardOutline.BoundingRectangle.Bottom),-3);
    grid := roundto(coordtomms(Board.ComponentGridSize),-3);
    if ((frac(x / grid) <> 0) or (frac(y / grid) <> 0))
    then Via.Selected := True;
    Via := Iter.NextPCBObject;
  end;
  Board.BoardIterator_Destroy(Iter);
  Client.PostMessage('PCB:RunQuery','Apply=True|Expr=IsSelected|Mask=True',
  Length('Apply=True|Expr=IsSelected|Mask=True'), Client.CurrentView);
end;