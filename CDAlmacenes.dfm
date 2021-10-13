object DAlmacenes: TDAlmacenes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 302
  Width = 564
  object dbCentral: TDatabase
    DatabaseName = 'dbCentral'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver1'
      'DATABASE NAME=comerbag'
      'USER NAME=informix'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER=DB850ES0'
      'SQLQRYMODE=SERVER'
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=1'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=informix')
    SessionName = 'Default'
    Left = 48
    Top = 24
  end
  object dbChanita: TDatabase
    DatabaseName = 'dbChanita'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver6'
      'DATABASE NAME=chanita'
      'USER NAME=informix'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER='
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=0'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=informix')
    SessionName = 'Default'
    Left = 352
    Top = 24
  end
  object dbFrutibon: TDatabase
    DatabaseName = 'dbFrutibon'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver8'
      'DATABASE NAME=comer'
      'USER NAME=informix'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER=DB850ES0'
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=0'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=informix')
    SessionName = 'Default'
    Left = 392
    Top = 24
  end
  object dbTenerife: TDatabase
    DatabaseName = 'dbTenerife'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver2'
      'DATABASE NAME=bagtfe'
      'USER NAME=informix'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER=DB850ES0'
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=0'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=informix')
    SessionName = 'Default'
    Left = 432
    Top = 24
  end
  object dbSevilla: TDatabase
    DatabaseName = 'dbSevilla'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver15'
      'DATABASE NAME=masetsev'
      'USER NAME=informix'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER=DB850ES0'
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=0'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=informix')
    SessionName = 'Default'
    Left = 472
    Top = 24
  end
  object QCentral: TQuery
    DatabaseName = 'dbCentral'
    RequestLive = True
    Left = 48
    Top = 80
  end
  object QAlmacen: TQuery
    Left = 312
    Top = 72
  end
  object QAux: TQuery
    DatabaseName = 'dbCentral'
    Left = 48
    Top = 128
  end
  object QOrden: TQuery
    Left = 472
    Top = 72
  end
  object QProductoBase: TQuery
    DatabaseName = 'dbCentral'
    Left = 120
    Top = 128
  end
  object QDetalleCentral: TQuery
    DatabaseName = 'dbCentral'
    RequestLive = True
    Left = 120
    Top = 80
  end
  object QProductoEnvase: TQuery
    DatabaseName = 'dbCentral'
    Left = 216
    Top = 128
  end
  object QDetalleAlmacen: TQuery
    DataSource = DSAlmacen
    Left = 392
    Top = 120
  end
  object DSAlmacen: TDataSource
    DataSet = QAlmacen
    Left = 392
    Top = 72
  end
  object QProductoEan: TQuery
    Left = 392
    Top = 176
  end
  object dbLlanos: TDatabase
    DatabaseName = 'dbLlanos'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver5'
      'DATABASE NAME=comersat'
      'USER NAME=informix'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER='
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=0'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=informix')
    SessionName = 'Default'
    Left = 296
    Top = 24
  end
end
