object DSincroData: TDSincroData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 711
  Top = 214
  Height = 474
  Width = 768
  object dbSAT: TDatabase
    DatabaseName = 'dbSAT'
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
    Left = 240
    Top = 24
  end
  object dbBAGChanita: TDatabase
    DatabaseName = 'dbBAGChanita'
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
    Left = 328
    Top = 144
  end
  object dbBAGP4H: TDatabase
    DatabaseName = 'dbBAGP4H'
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
    Left = 416
    Top = 144
  end
  object dbBAGTenerife: TDatabase
    DatabaseName = 'dbBAGTenerife'
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
    Left = 512
    Top = 144
  end
  object dbBAGSevilla: TDatabase
    DatabaseName = 'dbBAGSevilla'
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
    Left = 600
    Top = 144
  end
  object qrySAT: TQuery
    DatabaseName = 'dbSAT'
    RequestLive = True
    Left = 240
    Top = 72
  end
  object dbBAG: TDatabase
    DatabaseName = 'dbBAG'
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
    Left = 240
    Top = 144
  end
  object qryBAG: TQuery
    DatabaseName = 'dbBAG'
    Left = 240
    Top = 192
  end
  object qryBAGChanita: TQuery
    DatabaseName = 'dbBAGChanita'
    Left = 328
    Top = 192
  end
  object qryBAGP4H: TQuery
    DatabaseName = 'dbBAGP4H'
    Left = 416
    Top = 192
  end
  object qryBAGTenerife: TQuery
    DatabaseName = 'dbBAGTenerife'
    Left = 520
    Top = 192
  end
  object qryBAGSevilla: TQuery
    DatabaseName = 'dbBAGSevilla'
    Left = 600
    Top = 192
  end
  object dbSATTenerife: TDatabase
    DatabaseName = 'dbSATTenerife'
    DriverName = 'INFORMIX'
    LoginPrompt = False
    Params.Strings = (
      'SERVER NAME=iserver2'
      'DATABASE NAME=sattfe'
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
    Left = 416
    Top = 24
  end
  object dbSATLlanos: TDatabase
    DatabaseName = 'dbSATLlanos'
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
    Left = 328
    Top = 24
  end
  object qrySATLlanos: TQuery
    DatabaseName = 'dbSATLlanos'
    Left = 328
    Top = 72
  end
  object qrySATTenerife: TQuery
    DatabaseName = 'dbSATTenerife'
    Left = 416
    Top = 72
  end
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
    Left = 120
    Top = 24
  end
  object qryCentral: TQuery
    DatabaseName = 'dbCentral'
    RequestLive = True
    Left = 120
    Top = 72
  end
  object dbAlmacen: TDatabase
    DatabaseName = 'dbAlmacen'
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
    Left = 120
    Top = 144
  end
  object qryAlmacen: TQuery
    DatabaseName = 'dbAlmacen'
    Left = 120
    Top = 192
  end
  object dbRF: TDatabase
    DatabaseName = 'dbRF'
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
    Left = 240
    Top = 272
  end
  object qryRF: TQuery
    DatabaseName = 'dbRF'
    RequestLive = True
    Left = 240
    Top = 320
  end
end
