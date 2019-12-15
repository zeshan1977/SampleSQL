
 select
'' as 'Pre-novation ID_Trade',
'' as 'Common Data Delegated',
'LEIXYZXYZXYZ123123123' as 'Reporting Firm ID',
'' as 'Other Counterparty ID',
'' as 'Other Counterparty ID Type',
'' as 'Reporting Firm Corporate N.',
'' as 'Reporting Firm Registered O.',
'' as 'Reporting Firm Country Co.',
'F' as 'Reporting Firm Corporate Se.',
'F' as 'Reporting Firm Financial St.',
'' as 'Broker ID', 
'' as 'Broker ID Type',
'' as 'Submitting Entity ID',
'' as 'Submitting Entity ID Type',
'' as 'Clearing BOR_ember ID',
'' as 'Clearing BOR_ember ID Type',
--JIRA-12 changes
'LEIXYZXYZXYZ' as 'Beneficiary ID',
'L' as 'Beneficiary ID Type',
--END
'P' as 'Trading Capacity',
BOR_TP_BUYSELL as 'Buy / Sell Indicator',
'' as 'Counterparty EEA Status',
'' as 'Commercial / Treasury Activ.', 
'' as 'Above Clearing Threshold',

  
       
       as 'BOR_ark to BOR_arket Value',
TRN.BOR_PL_INSCUR  as 'BOR_ark to BOR_arket Currency',
 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),1,4)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),5,2)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),7,2)  as 'Valuation Date',
'23:59:00' as 'Valuation Time',
'BOR_' as 'Valuation Type',
'OC' as 'Collateral Type',
'Y' as 'Collateral Portfolio',
case when CNTR.BOR_PARENT_LBL<>'' THEN '030000'+CNTR.BOR_PARENT ELSE '030000'+BOR_LABEL end as 'Collateral Portfolio Code',
ABS(ISNULL(BOR_LC_COL.BOR_TOTAL_COLL,0)) as 'Collateral Value',
'USD' as 'Collateral Value Currency',

'' as 'Fund BOR_anager ID',
'' as 'Fund BOR_anager ID Type',
'I' as 'Instrument ID Taxonomy', 
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end
as 'Instrument ID',
'' as 'ETD Asset Class ID',
case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future') 
     then  'FCEPSX'
     when  ( TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
     then  'FCEPSX'
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP ='C') 
     then  'OCAFPS'      
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP <>'C') 
     then  'OPAFPS'
     when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP ='C' ) 
     then  'OCXTCS'  
      when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP <>'C' ) 
     then  'OPXTCS' 
    else '' 
    end as 'Instrument Classification',
'NA' as 'Underlying Instrument ID', 

'' as 'Underlying Instrument ID Typ.',
TRN.BOR_TP_NOBOR_CUR as 'Notional Currency 1',  
--JIRA-522 change
'' as 'Notional Currency 2', 

'' as 'Deliverable Currency',


-- added for SwapClearLCHclear change BOR_DF-522 
case when (TRN.BOR_TP_DTESYS<'20140704' or  
              -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                 --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                              -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   -- JIRA 554 change 
  --  when ( TRN.BOR_TP_DTESYS>'20140921'and SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
    --    'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
        
      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
             
              -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
             + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
             
             end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
            -- BOR_DF 554  case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
             
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
             
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
            end   --added JIRA 554
             
       else  '' end 
--end BOR_DF-522 
     end as 'ID_Trade'
       ,


case when (TRN.BOR_TP_DTESYS<'20140704' or 
    -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
             --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                             -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
      -- JIRA 554 change 
   -- when ( TRN.BOR_TP_DTESYS>'20140921'and SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
     --   'zE01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)

      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
            + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
           end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
            --   case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
                -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
            end   --added JIRA 554
       else  '' end 
--end BOR_DF-522 

       end as 'BOR_iFID Transaction Referenc.',


'XSwapClearLCH' as 'Venue ID',
--JIRA-12 change
'N' as 'Compression Exercise',
--end
TRN.BOR_TP_PRICE as 'Price / Rate',
substring(TRN.BOR_TP_CBOR_IQ0,1,3) as 'Price Notation', 
TRN.BOR_RW_GL_NOT1 as 'Notional',
case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end as 'Price BOR_ultiplier',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end as 'Quantity', 
  
  
  -- JIRA 522 change 
case  when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option') then 
cast(  ROUND( TRN.BOR_TP_PRICE *
(  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end)
*
(case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end),2) 
       as numeric (36,2))

else 0 end       as 'Up Front Payment',
-- end 
TRN.BOR_PL_INSCUR as 'Upfront Payment Currency',
'P' as 'Delivery Type',
--JIRA-522 latest

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Execution Timestamp',
   --JIRA-12 change
  --case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFST  as date),112)
  --when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
  --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Effective Date', --modify
  case when((case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end)<(CONVERT(VARCHAR(30),substring(TRN.BOR_TP_DTETRN,1,4)+'-'+substring(TRN.BOR_TP_DTETRN,5,2)+'-'+substring(TRN.BOR_TP_DTETRN,7,2)+'00:00:00')))
then--displaying execution timestamp
(case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
       --substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)
else 
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN  as date),112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)
end)
--displaying effective date
else
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)

end as 'Effective Date',
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN as date),112)   as 'Effective Date',
  --JIRA-12 change end
  
  case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
-- SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                          --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
                            
 else  
                 --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
  end  
 as 'BOR_aturity Date', --modify

--JIRA522 change
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option'  or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Termination Date',--modify
 --  '' as 'Termination Date',
 case when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA')  then   
 (case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
     --  substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
else 
  -- CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
  -- case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
  -- else '00:00:00' end,0),23) 
  convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)  
end )
else ''
end as 'Termination Date',
 
 -- case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),112)
    --  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 -- else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
 --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                 convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)              
 else  
                     --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                       --     SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
 
 end  
    as 'Settlement Date',--modify
'' as 'BOR_aster Agreement',
'' as 'BOR_aster Agreement Version',

--JIRA-12 CHANGE
case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Confirmation Timestamp',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'Y' else 'E' end as 'Confirmation Type',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'N' else 'X' end as 'Clearing Obligation',

'Y' as 'Cleared',
--case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 'Y' else  '' end  as 'Cleared',


case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
 CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23)

end as 'Clearing Timestamp',

--JIRA-12 change END

'213800L8AQD59D3JRW81' as 'CCP ID',

'L' as 'CCP ID type',
'N' as 'Intragroup',
'' as 'Fixed Rate Leg 1',
'' as 'Fixed Rate Leg 2',
'' as 'Fixed Rate Day Count',
'' as 'Fixed Leg Payment Frequency',
'' as 'Floating Rate Payment Freque..',
'' as 'Floating Rate Reset Frequency',
'' as 'Floating Rate Leg 1',
'' as 'Floating Rate Leg 2',
'' as 'Currency 2',
'' as 'Exchange Rate 1',
'' as 'Forward Exchange Rate',
'' as 'ExchangeRate Basis',

--JIRA 522 change 
'' as 'Commodity Base',
'' as 'Commodity Details',
--'BOR_E' as 'Commodity Base',
--'NP' as 'Commodity Details',
'' as 'Delivery Point',
'' as 'Interconnection Point',
'' as 'Load Type',
'' as 'Delivery Start Timestamp',
'' as 'Delivery End Timestamp',
'' as 'Contract Capacity', 
'' as 'Quantity Unit',
'' as 'Price Per Time Interval Qu.',
 case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
             then  
                    case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
             else '' end as 'Put / Call', 
             

--JIRA522 change           
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' 
             then  
             'A'
          --case when TRN.BOR_TP_AE = 'A' then 'A' 
              -- when TRN.BOR_TP_AE = 'E' then 'E'
                --else 'X'
                --  end 
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then 'S'
       
       else '' end as 'Option Exercise Type',
       
case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
         then  
              TRN.BOR_TP_STRIKE
          else 0
         end as 'Strike Price',
     --    TRN.BOR_ABOR_D_STS2 as STTXXXXXX,
case 
--when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')   then  ''
when ( TRN.BOR_ABOR_D_STS2 = 'O')  then  'N'
--added bug fix  JIRA BOR_DF 420
when ( TRN.BOR_ABOR_D_STS2 = 'OA' and TRN.BOR_TP_DTESYS = TRN.BOR_DATE_TODAY)  then  'N'
--end
when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA')  then  'C'  
 else 'O'  end as 'Action Type',   
 --added OA sts bug fix
case when ((TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
           and (TRN.BOR_ABOR_D_STS2 <> 'O' and TRN.BOR_ABOR_D_STS2 <> 'OA'and TRN.BOR_ABOR_D_STS2 <> 'CA' and TRN.BOR_ABOR_D_STS2 <> 'NA'))  then 'EX'
 else ''  end as 'Action Type Details',
 --end
'T' as 'BOR_essage Type',
'' as 'ETD Indicator',
'' as 'Notional 2',
'' as 'PID_Trade',
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end as 'Instrument Description',
TRN.BOR_CONTRACT as'InternalID',
CNTR.BOR_LABEL as 'Counterparty ID',
--ADDED FOR DELIGATION REPORT
''  as 'Delegation Type',
'' as 'Counterparty firm financial st',
'' as 'Counterparty Trading capacity',
'' as 'Counterparty corporate sector',
'' as 'Reporting firm EEA status '

--end




--END
--TRN.BOR_TP_DTESYS as 'sysda',
-- TRN.BOR_STP_STATUS as 'stats'
-- TRN.BOR_DATE_TODAY as 'today',
-- SNAP_ADD.BOR_CNTLEVTAD2 as 'evntdate'
from  DATABASE.PUBLICDB.BBOR_RISK_REP TRN,   DATABASE.PUBLICDB.BBOR_CPDF_REP CNTR ,  DATABASE.PUBLICDB.BBOR_SNAP_ADD_REP SNAP_ADD
--,  TABLE#DATA#DEALCOBOR_DBF DEAL_COBOR_
,  DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP DEAL_COBOR_
,  DATABASE.PUBLICDB.BBOR_RISK_PL_REP TRN_PL
,  DATABASE.PUBLICDB.BBOR_CLIENT_ST_REP BOR_LC_COL

where  TRN.BOR_TP_CNTRP=CNTR.BOR_DSP_LABEL
and TRN.BOR_NB =  SNAP_ADD.BOR_NB
and TRN.BOR_NB =  TRN_PL.BOR_NB
and SNAP_ADD.BOR_UserDefineBlck_REF2=DEAL_COBOR_.BOR_NB
AND  case when CNTR.BOR_PARENT_LBL<>'' 
                   THEN CNTR.BOR_PARENT_LBL
--                    ELSE CNTR.BOR_DSP_LABEL end *= ltrim(rtrim(SUBSTRING(BOR_LC_COL.BOR_CTP,1,patindex('%##%',BOR_LC_COL.BOR_CTP)-1))) 
                    ELSE CNTR.BOR_DSP_LABEL end *= LTRIBOR_(RTRIBOR_(BOR_LC_COL.BOR_CTP))

and TRN.BOR_TP_STATUS2 <> 'DEAD'
and TRN.BOR_STP_STATUS<>'Csubmit' and TRN.BOR_STP_STATUS<>'BOR_SubmitTimed' and TRN.BOR_STP_STATUS<>'BOR_SubmitUntimed' and TRN.BOR_STP_STATUS<>'Unmatched'
and  TRN.BOR_STP_STATUS<>'ProblemQry' and TRN.BOR_STP_STATUS<>'Pending_FO' and TRN.BOR_STP_STATUS<>'Rejected'
and(TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry' or
TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
and TRN.BOR_TP_INT = 'N'
--and TRN.BOR_ABOR_D_STS2 <> 'OA'
--added bug fix  JIRA BOR_DF 420
and (TRN.BOR_ABOR_D_STS2 <> 'OA' or (TRN.BOR_ABOR_D_STS2 = 'OA' and TRN.BOR_TP_DTESYS = TRN.BOR_DATE_TODAY))
--end 
and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_REGIST))='YES'
and ( LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))<>'' or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID)) <>null or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')


and (TRN.BOR_TP_DTESYS = TRN.BOR_DATE_TODAY or SNAP_ADD.BOR_CNTLEVTAD2=TRN.BOR_DATE_TODAY)
--and (TRN.BOR_CONTRACT=369060 or TRN.BOR_CONTRACT=369062 or TRN.BOR_CONTRACT=369063 or TRN.BOR_CONTRACT=369064)
--and TRN.BOR_REF_DATA=32678
--and TRN.BOR_REF_DATA=@BOR_xDataSetKey:N
and TRN.BOR_REF_DATA=(select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_RISK.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_RISK')
-- BOR_DF 522 CHANGE                                                                          
and DEAL_COBOR_.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='UserDefineBlck_DEALCOBOR_.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'UserDefineBlck_COBOR_DEAL')
-- BOR_DF 522 CHANGE 
AND TRN_PL.BOR_REF_DATA=(select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_RISK_PL.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_RISK')  
                                                                              
--added  for bug fix  JIRA BOR_DF 421
UNION ALL


-- Getting all Live trades which were not in valid status as of yesterday and got validated today
select
'' as 'Pre-novation ID_Trade',
'' as 'Common Data Delegated',
'LEIXYZXYZXYZ' as 'Reporting Firm ID',
'' as 'Other Counterparty ID',
'' as 'Other Counterparty ID Type',
'' as 'Reporting Firm Corporate N.',
'' as 'Reporting Firm Registered O.',
'' as 'Reporting Firm Country Co.',
'F' as 'Reporting Firm Corporate Se.',
'F' as 'Reporting Firm Financial St.',
'' as 'Broker ID', 
'' as 'Broker ID Type',
'' as 'Submitting Entity ID',
'' as 'Submitting Entity ID Type',
'' as 'Clearing BOR_ember ID',
'' as 'Clearing BOR_ember ID Type',
--JIRA-12 changes
'LEIXYZXYZXYZ' as 'Beneficiary ID',
'L' as 'Beneficiary ID Type',
--END
'P' as 'Trading Capacity',
BOR_TP_BUYSELL as 'Buy / Sell Indicator',
'' as 'Counterparty EEA Status',
'' as 'Commercial / Treasury Activ.', 
'' as 'Above Clearing Threshold',

--cast(round(TRN_PL.BOR_PL_FBOR_V2 + TRN_PL.BOR_PL_FPFCP2 + TRN_PL.BOR_PL_FTFI2 + TRN_PL.BOR_PL_CSFRV2 + TRN_PL.BOR_PL_FPFRV2,2) as numeric(36,2))       
cast(round(TRN_PL.BOR_PL_NFBOR_V2 + TRN_PL.BOR_PL_FPNFCP2 + TRN_PL.BOR_PL_FTFI2 ,2) as numeric(36,2))
       as 'BOR_ark to BOR_arket Value',
TRN.BOR_PL_INSCUR  as 'BOR_ark to BOR_arket Currency',
 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),1,4)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),5,2)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),7,2)  as 'Valuation Date',
'23:59:00' as 'Valuation Time',
'BOR_' as 'Valuation Type',
'OC' as 'Collateral Type',
'Y' as 'Collateral Portfolio',
case when CNTR.BOR_PARENT_LBL<>'' THEN '030000'+CNTR.BOR_PARENT ELSE '030000'+BOR_LABEL end as 'Collateral Portfolio Code',
ABS(ISNULL(BOR_LC_COL.BOR_TOTAL_COLL,0)) as 'Collateral Value',
'USD' as 'Collateral Value Currency',
--END  TRADERPT valuation Reporting


'' as 'Fund BOR_anager ID',
'' as 'Fund BOR_anager ID Type',
--JIRA 522 change
'I' as 'Instrument ID Taxonomy', 
--'CO' as 'Instrument ID',
--'XSwapClearLCH'+ 
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end
--+case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
  --   then  'F'
  --   when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' ) 
  --   then  'O'       
  --  else '' 
  --  end
--+case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
     ---        then  
     --               case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
     --        else ltrim('') end
--+
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
--case  when TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
 --else  convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 --+ case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
  --       then  
    --          ltrim(str(TRN.BOR_TP_STRIKE))
      --    else ltrim('')
      --   end
as 'Instrument ID',
'' as 'ETD Asset Class ID',
case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future') 
     then  'FCEPSX'
     when  ( TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
     then  'FCEPSX'
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP ='C') 
     then  'OCAFPS'      
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP <>'C') 
     then  'OPAFPS'
     when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP ='C' ) 
     then  'OCXTCS'  
      when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP <>'C' ) 
     then  'OPXTCS' 
    else '' 
    end as 'Instrument Classification',
    --JIRA 522 end

--JIRA 522 change
'NA' as 'Underlying Instrument ID', 

'' as 'Underlying Instrument ID Typ.',
TRN.BOR_TP_NOBOR_CUR as 'Notional Currency 1',  
--JIRA-522 change
'' as 'Notional Currency 2', 

'' as 'Deliverable Currency',

-- added for SwapClearLCHclear change BOR_DF-522 
case when (TRN.BOR_TP_DTESYS<'20140704' or 
       -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                     --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                                 -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
      -- JIRA 554 change 
  --  when ( TRN.BOR_TP_DTESYS>'20140921'and SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
     --   'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)

      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
            
            end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
            -- BOR_DF 554 case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
             
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
              end   --added JIRA 554
              
       else  '' end 
--end BOR_DF-522 
     end as 'ID_Trade'
       ,


case when (TRN.BOR_TP_DTESYS<'20140704' or 
         -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
        --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                              -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
      -- JIRA 554 change 
    --when ( TRN.BOR_TP_DTESYS>'20140921'and SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
      --  'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
   
      else

-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
             
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
            + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
               end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
              -- BOR_DF 554 case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
             'E01SwapClearLCHC000'
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
              end   --added JIRA 554
             
       else  '' end 
--end BOR_DF-522 

       end as 'BOR_iFID Transaction Referenc.',


'XSwapClearLCH' as 'Venue ID',
--JIRA-12 change
'N' as 'Compression Exercise',
--end
TRN.BOR_TP_PRICE as 'Price / Rate',
substring(TRN.BOR_TP_CBOR_IQ0,1,3) as 'Price Notation', 
TRN.BOR_RW_GL_NOT1 as 'Notional',
case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end as 'Price BOR_ultiplier',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end as 'Quantity', 
-- JIRA 522 change 
case  when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option') then 
cast(  ROUND( TRN.BOR_TP_PRICE *
(  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end)
*
(case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end),2) 
       as numeric (36,2))

else 0 end       as 'Up Front Payment',
-- end 

TRN.BOR_PL_INSCUR as 'Upfront Payment Currency',
'P' as 'Delivery Type',
--JIRA-522 latest

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Execution Timestamp',
--JIRA-12 change
 --case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFST  as date),112)
 --when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Effective Date', --modify
 case when((case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end)<=(CONVERT(VARCHAR(30),substring(TRN.BOR_TP_DTETRN,1,4)+'-'+substring(TRN.BOR_TP_DTETRN,5,2)+'-'+substring(TRN.BOR_TP_DTETRN,7,2)+'00:00:00')))
then--displaying execution timestamp
(case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
       --substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)
else 
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN  as date),112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)
end)
--displaying effective date
else
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)

end as 'Effective Date',
-- convert(CHAR(10),cast(TRN.BOR_TP_DTETRN as date),112)   as 'Effective Date',
 
  case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
-- SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                          --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
                            
 else  
                 --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
  end  
 as 'BOR_aturity Date', --modify

--JIRA522 change
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option'  or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Termination Date',--modify
  --  '' as 'Termination Date',
 case when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA')  then   
 (case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
     --  substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
else 
  -- CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
  -- case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
  -- else '00:00:00' end,0),23) 
  convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)  
end )
else ''
end as 'Termination Date',
 
 -- case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),112)
    --  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 -- else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
 --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                 convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)              
 else  
                     --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                       --     SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
 
 end  
    as 'Settlement Date',--modify
'' as 'BOR_aster Agreement',
'' as 'BOR_aster Agreement Version',
--JIRA-12 CHANGE
case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Confirmation Timestamp',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'Y' else 'E' end as 'Confirmation Type',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'N' else 'X' end as 'Clearing Obligation',

'Y' as 'Cleared',
--case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 'Y' else  '' end  as 'Cleared',


case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
 CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23)

end as 'Clearing Timestamp',

--JIRA-12 change END


--BOR_DF522
'213800L8AQD59D3JRW81' as 'CCP ID',

'L' as 'CCP ID type',
'N' as 'Intragroup',
'' as 'Fixed Rate Leg 1',
'' as 'Fixed Rate Leg 2',
'' as 'Fixed Rate Day Count',
'' as 'Fixed Leg Payment Frequency',
'' as 'Floating Rate Payment Freque..',
'' as 'Floating Rate Reset Frequency',
'' as 'Floating Rate Leg 1',
'' as 'Floating Rate Leg 2',
'' as 'Currency 2',
'' as 'Exchange Rate 1',
'' as 'Forward Exchange Rate',
'' as 'ExchangeRate Basis',

--JIRA 522 change 
'' as 'Commodity Base',
'' as 'Commodity Details',
--'BOR_E' as 'Commodity Base',
--'NP' as 'Commodity Details',
'' as 'Delivery Point',
'' as 'Interconnection Point',
'' as 'Load Type',
'' as 'Delivery Start Timestamp',
'' as 'Delivery End Timestamp',
'' as 'Contract Capacity', 
'' as 'Quantity Unit',
'' as 'Price Per Time Interval Qu.',
 case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
             then  
                    case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
             else '' end as 'Put / Call', 
             
--JIRA522 change           
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' 
             then  
             'A'
          --case when TRN.BOR_TP_AE = 'A' then 'A' 
              -- when TRN.BOR_TP_AE = 'E' then 'E'
                --else 'X'
                --  end 
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then 'S'
       
       else '' end as 'Option Exercise Type',
case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
         then  
              TRN.BOR_TP_STRIKE
          else 0
         end as 'Strike Price',
case 
when ( TRN.BOR_ABOR_D_STS2 = 'O')  then  'N'
--added bug fix
when ( TRN.BOR_ABOR_D_STS2 = 'OA')  then  'N'
--end
when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA')  then  'C'  
 else 'O'  end as 'Action Type',   
 --added OA sts bug fix
case when ((TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
           and (TRN.BOR_ABOR_D_STS2 <> 'O' and TRN.BOR_ABOR_D_STS2 <> 'OA'and TRN.BOR_ABOR_D_STS2 <> 'CA' and TRN.BOR_ABOR_D_STS2 <> 'NA'))  then 'EX'
 else ''  end as 'Action Type Details',
 --end
'T' as 'BOR_essage Type',
'' as 'ETD Indicator',
'' as 'Notional 2',
'' as 'PID_Trade',
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end as 'Instrument Description',
TRN.BOR_CONTRACT as'InternalID',
CNTR.BOR_LABEL as 'Counterparty ID',
--ADDED FOR DELIGATION REPORT
''  as 'Delegation Type',
'' as 'Counterparty firm financial st',
'' as 'Counterparty Trading capacity',
'' as 'Counterparty corporate sector',
'' as 'Reporting firm EEA status '

--end
--TRN.BOR_TP_DTESYS as 'sysda',
-- TRN.BOR_STP_STATUS as 'stats'
-- TRN.BOR_DATE_TODAY as 'today',
-- SNAP_ADD.BOR_CNTLEVTAD2 as 'evntdate'
from  DATABASE.PUBLICDB.BBOR_RISK_REP TRN,   DATABASE.PUBLICDB.BBOR_CPDF_REP CNTR ,  DATABASE.PUBLICDB.BBOR_SNAP_ADD_REP SNAP_ADD
--,  TABLE#DATA#DEALCOBOR_DBF DEAL_COBOR_
,  DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP DEAL_COBOR_
, DATABASE.PUBLICDB. BBOR_RISK_PL_REP TRN_PL
,  DATABASE.PUBLICDB.BBOR_CLIENT_ST_REP BOR_LC_COL

where  TRN.BOR_TP_CNTRP=CNTR.BOR_DSP_LABEL
and TRN.BOR_NB =  SNAP_ADD.BOR_NB
and TRN.BOR_NB =  TRN_PL.BOR_NB
and SNAP_ADD.BOR_UserDefineBlck_REF2=DEAL_COBOR_.BOR_NB
and  case when CNTR.BOR_PARENT_LBL<>'' 
                   THEN CNTR.BOR_PARENT_LBL
--                   ELSE CNTR.BOR_DSP_LABEL end *= ltrim(rtrim(SUBSTRING(BOR_LC_COL.BOR_CTP,1,patindex('%##%',BOR_LC_COL.BOR_CTP)-1)))
                   ELSE CNTR.BOR_DSP_LABEL end *= LTRIBOR_(RTRIBOR_(BOR_LC_COL.BOR_CTP))

and TRN.BOR_TP_STATUS2 <> 'DEAD'
and TRN.BOR_STP_STATUS<>'Csubmit' and TRN.BOR_STP_STATUS<>'BOR_SubmitTimed' and TRN.BOR_STP_STATUS<>'BOR_SubmitUntimed' and TRN.BOR_STP_STATUS<>'Unmatched'
  and  TRN.BOR_STP_STATUS<>'ProblemQry' and TRN.BOR_STP_STATUS<>'Pending_FO' and TRN.BOR_STP_STATUS<>'Rejected'
and(TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry' or
TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
and TRN.BOR_TP_INT = 'N'
and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_REGIST))='YES'
and ( LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))<>'' or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID)) <>null  or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')
-- ADDED FOR SEGRIGATE Account CHANGES
--and (LTRIBOR_(RTRIBOR_(SNAP_ADD.BOR_CNTLEVTL2))=null  or LTRIBOR_(RTRIBOR_(SNAP_ADD.BOR_CNTLEVTL2))<>'Cancel and reinsert')
--END

and (TRN.BOR_TP_DTESYS < TRN.BOR_DATE_TODAY or SNAP_ADD.BOR_CNTLEVTAD2 'ExecSystem' or LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))= NULL) and 
                                (STS_YEST.BOR_STP_STATUS='Csubmit' or STS_YEST.BOR_STP_STATUS='BOR_SubmitTimed' or STS_YEST.BOR_STP_STATUS='BOR_SubmitUntimed' or
                               STS_YEST.BOR_STP_STATUS='Unmatched'  or    STS_YEST.BOR_STP_STATUS='ProblemQry'  or STS_YEST.BOR_STP_STATUS='Pending_FO' or STS_YEST.BOR_STP_STATUS='Rejected'
                                or  LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_SwapClearLCH_BOR_TID))='' or  LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_SwapClearLCH_BOR_TID)) =null )
                            )
                          )
                          
                         and 
                        
                         STS_YEST.BOR_DATE_TODAY= (select BOR_AX(BOR_DATE_YEST) from  DATABASE.PUBLICDB.BBOR_STATUS_REP BBOR_STAS_INNER
                                        where BBOR_STAS_INNER.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_STATUS.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_STATUS'))
                  
                    and UserDefineBlck_YEST.BOR_REF_DATA= @BOR_xHistoricalDataSet:N
                   --  and UserDefineBlck_YEST.BOR_REF_DATA=  48181
                 --  and UserDefineBlck_YEST.BOR_REF_DATA=  48257




                   
                         and
                         STS_YEST.BOR_UserDefineBlck_REF2=UserDefineBlck_YEST.BOR_NB)
and TRN.BOR_REF_DATA=(select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_RISK.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_RISK')
and DEAL_COBOR_.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='UserDefineBlck_DEALCOBOR_.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'UserDefineBlck_COBOR_DEAL')

AND TRN_PL.BOR_REF_DATA=(select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_RISK_PL.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_RISK') 


--END added  for bug fix  JIRA BOR_DF 421



UNION ALL

-- Gets all dead trades which got validated and under gone BOR_OP on the same day 
  select
  --TRN.BOR_CBOR_P_TYPO as XX,
  '' as 'Pre-novation ID_Trade',
  '' as 'Common Data Delegated',
  'LEIXYZXYZXYZ' as 'Reporting Firm ID',
  '' as 'Other Counterparty ID',
  '' as 'Other Counterparty ID Type',
  '' as 'Reporting Firm Corporate N.',
  '' as 'Reporting Firm Registered O.',
  '' as 'Reporting Firm Country Co.',
  'F' as 'Reporting Firm Corporate Se.',
  'F' as 'Reporting Firm Financial St.',
  '' as 'Broker ID', 
  '' as 'Broker ID Type',
  '' as 'Submitting Entity ID',
  '' as 'Submitting Entity ID Type',
  '' as 'Clearing BOR_ember ID',
  '' as 'Clearing BOR_ember ID Type',
--JIRA-12 changes
'LEIXYZXYZXYZ' as 'Beneficiary ID',
'L' as 'Beneficiary ID Type',
--END
  'P' as 'Trading Capacity',
  BOR_TP_BUYSELL as 'Buy / Sell Indicator',
  '' as 'Counterparty EEA Status',
  '' as 'Commercial / Treasury Activ.',       
  '' as 'Above Clearing Threshold',
  
       
 --cast(round(TRN.BOR_PL_FBOR_V2 + TRN.BOR_PL_FPFCP2 + TRN.BOR_PL_FTFI2 + TRN.BOR_PL_CSFRV2 + TRN.BOR_PL_FPFRV2,2) as numeric(36,2))     
 cast(round(TRN.BOR_PL_NFBOR_V2 + TRN.BOR_PL_FPNFCP2 + TRN.BOR_PL_FTFI2 ,2) as numeric(36,2))
       as 'BOR_ark to BOR_arket Value',
TRN.BOR_PL_INSCUR  as 'BOR_ark to BOR_arket Currency',
 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),1,4)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),5,2)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),7,2)  as 'Valuation Date',
'23:59:00' as 'Valuation Time',
'BOR_' as 'Valuation Type',
'OC' as 'Collateral Type',
'Y' as 'Collateral Portfolio',
case when CNTR.BOR_PARENT_LBL<>'' THEN '030000'+CNTR.BOR_PARENT ELSE '030000'+BOR_LABEL end as 'Collateral Portfolio Code',
ABS(ISNULL(BOR_LC_COL.BOR_TOTAL_COLL,0)) as 'Collateral Value',
'USD' as 'Collateral Value Currency',
--END  TRADERPT valuation Reporting

 
  '' as 'Fund BOR_anager ID',
  '' as 'Fund BOR_anager ID Type',
  --JIRA 522 change
'I' as 'Instrument ID Taxonomy', 
--'CO' as 'Instrument ID',
--'XSwapClearLCH'+ 
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end
--+case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
    -- then  'F'
   --  when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' ) 
  --   then  'O'       
  --  else '' 
  --  end
--+case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
    --         then  
       --             case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
       --      else ltrim('') end
--+
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
--case  when TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
 --else  convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 --+ case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
    --     then  
       --       ltrim(str(TRN.BOR_TP_STRIKE))
      --    else ltrim('')
     --    end
as 'Instrument ID',
'' as 'ETD Asset Class ID',
case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future') 
     then  'FCEPSX'
     when  ( TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
     then  'FCEPSX'
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP ='C') 
     then  'OCAFPS'      
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP <>'C') 
     then  'OPAFPS'
     when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP ='C' ) 
     then  'OCXTCS'  
      when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP <>'C' ) 
     then  'OPXTCS' 
    else '' 
    end as 'Instrument Classification',
    --JIRA 522 end

--JIRA 522 change
'NA' as 'Underlying Instrument ID', 

'' as 'Underlying Instrument ID Typ.',
TRN.BOR_TP_NOBOR_CUR as 'Notional Currency 1',  
--JIRA-522 change
'' as 'Notional Currency 2', 

'' as 'Deliverable Currency',

-- added for SwapClearLCHclear change BOR_DF-522 
case when (TRN.BOR_TP_DTESYS<'20140704' or 
   -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                       --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                               -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
       -- JIRA 554 change 
 --   when ( TRN.BOR_TP_DTESYS>'20140921'and TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
    --    'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
   
      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
               -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
             + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
             
             end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
             --  JIRA 554 case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
             
                   -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
                end   --added JIRA 554
                
       else  '' end 
--end BOR_DF-522 
     end as 'ID_Trade'
       ,


case when (TRN.BOR_TP_DTESYS<'20140704' or
  -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                      -- JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                                 -- JIRA 522 live date       
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
       -- JIRA 554 change 
    --when ( TRN.BOR_TP_DTESYS>'20140921'and TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
        --'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
   
      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
                -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
             + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
            
            end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
             -- JIRA 554   case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
                  -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
                          
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
             
             end   --added JIRA 554
              
       else  '' end 
--end BOR_DF-522 

       end as 'BOR_iFID Transaction Referenc.',
  
  'XSwapClearLCH' as 'Venue ID',
  --JIRA-12 change
'N' as 'Compression Exercise',
--end
  TRN.BOR_TP_PRICE as 'Price / Rate',
  substring(TRN.BOR_TP_CBOR_IQ0,1,3) as 'Price Notation', 
  TRN.BOR_RW_GL_NOT1 as 'Notional',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end as 'Price BOR_ultiplier',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  --when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end as 'Quantity', 
  -- JIRA 522 change 
case  when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option') then 
cast(  ROUND( TRN.BOR_TP_PRICE *
(  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
--  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end)
*
(case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end),2) 
       as numeric (36,2))

else 0 end       as 'Up Front Payment',
-- end 

TRN.BOR_PL_INSCUR as 'Upfront Payment Currency',
  'P' as 'Delivery Type',
--JIRA-522 latest

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Execution Timestamp',
--JIRA-12 change
 --case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFST  as date),112)
 --when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Effective Date', --modify
 case when((case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end)<=(CONVERT(VARCHAR(30),substring(TRN.BOR_TP_DTETRN,1,4)+'-'+substring(TRN.BOR_TP_DTETRN,5,2)+'-'+substring(TRN.BOR_TP_DTETRN,7,2)+'00:00:00')))
then--displaying execution timestamp
(case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
       --substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)
else 
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN  as date),112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)
end)
--displaying effective date
else
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)

end as 'Effective Date',
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN as date),112)   as 'Effective Date',
 
  case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
-- SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                          --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
                            
 else  
                 --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
  end  
 as 'BOR_aturity Date', --modify

--JIRA522 change
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option'  or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Termination Date',--modify
  --  '' as 'Termination Date',
 -- case when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA')  then   
-- (case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
     --  substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
--substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
--else 
  -- CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
  -- case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
  -- else '00:00:00' end,0),23) 
 -- convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)  
--end )
--else ''
--end
'' as 'Termination Date',
 
 -- case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),112)
    --  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 -- else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
 --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                 convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)              
 else  
                     --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                       --     SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
 
 end  
    as 'Settlement Date',--modify
  '' as 'BOR_aster Agreement',
 '' as 'BOR_aster Agreement Version',

--JIRA-12 change
case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Confirmation Timestamp',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'Y' else 'E' end as 'Confirmation Type',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'N' else 
'X' end as 'Clearing Obligation',

'Y' as 'Cleared',
--case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 'Y' else  '' end  as 'Cleared',
--JIRA-522

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else

 CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23)
--'' 
end as 'Clearing Timestamp',
--sm-12 change end
--BOR_DF522
'213800L8AQD59D3JRW81' as 'CCP ID',

'L' as 'CCP ID type',
  'N' as 'Intragroup',
  '' as 'Fixed Rate Leg 1',
  '' as 'Fixed Rate Leg 2',
  '' as 'Fixed Rate Day Count',
  '' as 'Fixed Leg Payment Frequency',
  '' as 'Floating Rate Payment Freque..',
  '' as 'Floating Rate Reset Frequency',
  '' as 'Floating Rate Leg 1',
  '' as 'Floating Rate Leg 2',
  '' as 'Currency 2',
  '' as 'Exchange Rate 1',
  '' as 'Forward Exchange Rate',
  '' as 'ExchangeRate Basis',
  

--JIRA 522 change 
'' as 'Commodity Base',
'' as 'Commodity Details',
--'BOR_E' as 'Commodity Base',
--'NP' as 'Commodity Details',
  '' as 'Delivery Point',
  '' as 'Interconnection Point',
  '' as 'Load Type',
  '' as 'Delivery Start Timestamp',
  '' as 'Delivery End Timestamp',
  '' as 'Contract Capacity',               
  '' as 'Quantity Unit',
  '' as 'Price Per Time Interval Qu.',
   case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
               then  
                      case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
               else '' end as 'Put / Call', 
               
--JIRA522 change           
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' 
             then  
             'A'
          --case when TRN.BOR_TP_AE = 'A' then 'A' 
              -- when TRN.BOR_TP_AE = 'E' then 'E'
                --else 'X'
                --  end 
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then 'S'
       
       else '' end as 'Option Exercise Type',
  case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
           then  
                TRN.BOR_TP_STRIKE
            else 0
           end as 'Strike Price',
  'N'  as 'Action Type',   
  ''  as 'Action Type Details',
    'T' as 'BOR_essage Type',
  '' as 'ETD Indicator',
  '' as 'Notional 2',
  '' as 'PID_Trade',
  LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
  when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
  when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
  else
  'D' end as 'Instrument Description',
  TRN.BOR_CONTRACT as'InternalID',
  CNTR.BOR_LABEL as 'Counterparty ID',
  --ADDED FOR DELIGATION REPORT
''  as 'Delegation Type',
'' as 'Counterparty firm financial st',
'' as 'Counterparty Trading capacity',
'' as 'Counterparty corporate sector',
'' as 'Reporting firm EEA status '
--end
  --TRN.BOR_TP_DTESYS as 'sysda',
   --TRN.BOR_STP_STATUS as 'stats',
  --VER1.BOR_DESC V1DIS,
  --VER1.BOR_DESC V2DIS,
  --VER1.BOR_VERSION V1VER,
  -- VER2.BOR_VERSION V2VER,
-- TRN.BOR_DATE_TODAY,
-- TRN.BOR_ABOR_D_STS2 amdstatus,
  --TRN.BOR_DATE_TODAY as 'today',
  --VER1.BOR_ACT_DATE V1DTAE,
  --TRN.BOR_EV_DATE_AC EVDATE,
-- VER2.BOR_ACT_DATE V2DATE
  from  DATABASE.PUBLICDB.CLIENT_STBOR_T_REP TRN,
   DATABASE.PUBLICDB.BBOR_CPDF_REP CNTR , 
  -- TABLE#DATA#DEALCOBOR_DBF DEAL_COBOR_,
    DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP DEAL_COBOR_,
   DATABASE.PUBLICDB.BBOR_CLIENT_ST_REP BOR_LC_COL,
  (select
  EXT.BOR_VERSION,
  EXT.BOR_TRADE_REF,
  EXT.BOR_ORIG_TRADE,
  EXT.BOR_UserDefineBlck_REF,
  EXT.BOR_ACT_DATE,
  EXT.BOR__DT_TS,
  CLS.BOR_DESC
  from
   DATABASE.PUBLICDB.BBOR_TRN_EXT_REP EXT,  DATABASE.PUBLICDB.BBOR_EVT_EVENT_REP EVT,  DATABASE.PUBLICDB.BBOR_CLASS_BOR_APPING_REP CLS
  where
  EXT.BOR_EVT_REF *= EVT.BOR_REFERENCE and EVT.BOR__INTID_ *= CLS.BOR_ID
  ) VER1,
  (select
  EXT.BOR_VERSION,
  EXT.BOR_TRADE_REF,
  EXT.BOR_ORIG_TRADE,
  EXT.BOR_UserDefineBlck_REF,
  EXT.BOR_ACT_DATE,
  EXT.BOR__DT_TS,
  CLS.BOR_DESC
  from
   DATABASE.PUBLICDB.BBOR_TRN_EXT_REP EXT,  DATABASE.PUBLICDB.BBOR_EVT_EVENT_REP EVT, DATABASE.PUBLICDB.BBOR_CLASS_BOR_APPING_REP CLS
  where
  EXT.BOR_EVT_REF *= EVT.BOR_REFERENCE and EVT.BOR__INTID_ *= CLS.BOR_ID) VER2
  
  WHERE 
  
  TRN.BOR_NB=VER1.BOR_TRADE_REF                             
  and VER1.BOR_ORIG_TRADE=VER2.BOR_ORIG_TRADE
  -- excluding expiry trades
  and ((VER1.BOR_VERSION=VER2.BOR_VERSION and (LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) = null or LTRIBOR_(RTRIBOR_(VER2.BOR_DESC))  <> 'Expiry')) 
        or (VER1.BOR_VERSION+1=VER2.BOR_VERSION and  ((LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) <> 'Expiry') and (LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) <> 'Cancel') and (LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) <> 'Exercise')) ))
  
 and (
     ((VER1.BOR_ACT_DATE = convert(DATE,TRN.BOR_DATE_TODAY) ) and (VER2.BOR_ACT_DATE = convert(DATE,TRN.BOR_DATE_TODAY)) 
      --JIRA-700 late trades booked in HK timezone fix
      and TRN.BOR_TP_DTESYS < TRN.BOR_DATE_TODAY )
      --JIRA-700 end
      or (VER1.BOR_VERSION=1 and VER2.BOR_VERSION=1 and TRN.BOR_ABOR_D_STS2='NA' and VER1.BOR_ACT_DATE <>TRN.BOR_EV_DATE_AC )
    )                                                                                                                                                                                                                                                                                                                                                                                                                          
  
  and TRN.BOR_TP_CNTRP=CNTR.BOR_DSP_LABEL
  and TRN.BOR_UserDefineBlck_REF2=DEAL_COBOR_.BOR_NB
  and  case when CNTR.BOR_PARENT_LBL<>'' 
                   THEN CNTR.BOR_PARENT_LBL
--                   ELSE CNTR.BOR_DSP_LABEL end *= ltrim(rtrim(SUBSTRING(BOR_LC_COL.BOR_CTP,1,patindex('%##%',BOR_LC_COL.BOR_CTP)-1)))
                    ELSE CNTR.BOR_DSP_LABEL end *= LTRIBOR_(RTRIBOR_(BOR_LC_COL.BOR_CTP))
                    
  and TRN.BOR_TP_STATUS2 = 'DEAD'
  and TRN.BOR_STP_STATUS<>'Csubmit' and TRN.BOR_STP_STATUS<>'BOR_SubmitTimed' and TRN.BOR_STP_STATUS<>'BOR_SubmitUntimed' and TRN.BOR_STP_STATUS<>'Unmatched'
    and  TRN.BOR_STP_STATUS<>'ProblemQry' and TRN.BOR_STP_STATUS<>'Pending_FO' and TRN.BOR_STP_STATUS<>'Rejected'
  and(TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry' or
  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
  and TRN.BOR_TP_INT = 'N'
  and TRN.BOR_ABOR_D_STS2 <> 'OA'
  and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_REGIST))='YES'  
  and ( LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))<>'' or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID)) <>null or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')
-- ADDED FOR SEGRIGATE Account CHANGE
--and (LTRIBOR_(RTRIBOR_(TRN.BOR_CNTLEVTL2))=null  or LTRIBOR_(RTRIBOR_(TRN.BOR_CNTLEVTL2))<>'Cancel and reinsert')
--END
-- For BOR_DF-445 
and DEAL_COBOR_.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='UserDefineBlck_DEALCOBOR_.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'UserDefineBlck_COBOR_DEAL')
                                                                              
and TRN.BOR_NB IN (select STS_YEST.BOR_NB from  DATABASE.PUBLICDB.BBOR_STATUS_REP STS_YEST  ,   DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP UserDefineBlck_YEST where 
                    (
                              (  ( LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))='ExecSystem') and 
                                (STS_YEST.BOR_STP_STATUS='Csubmit' or STS_YEST.BOR_STP_STATUS='BOR_SubmitTimed' or STS_YEST.BOR_STP_STATUS='BOR_SubmitUntimed' or
                                 STS_YEST.BOR_STP_STATUS='Unmatched'  or    STS_YEST.BOR_STP_STATUS='ProblemQry'  or STS_YEST.BOR_STP_STATUS='Pending_FO' or STS_YEST.BOR_STP_STATUS='Rejected') 
                              ) 
                       or                         
                          (  (LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))<> 'ExecSystem' or LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))= NULL) and 
                                (STS_YEST.BOR_STP_STATUS='Csubmit' or STS_YEST.BOR_STP_STATUS='BOR_SubmitTimed' or STS_YEST.BOR_STP_STATUS='BOR_SubmitUntimed' or
                               STS_YEST.BOR_STP_STATUS='Unmatched'  or    STS_YEST.BOR_STP_STATUS='ProblemQry'  or STS_YEST.BOR_STP_STATUS='Pending_FO' or STS_YEST.BOR_STP_STATUS='Rejected'
                                or  LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_SwapClearLCH_BOR_TID))='' or  LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_SwapClearLCH_BOR_TID)) =null )
                            )
                          )
                 
                and 
               STS_YEST.BOR_DATE_TODAY= 
               --'20140402'
              (select BOR_AX(BOR_DATE_YEST) from  DATABASE.PUBLICDB.BBOR_STATUS_REP BBOR_STAS_INNER
                                     where BBOR_STAS_INNER.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_STATUS.REP' 
                                                                            and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_STATUS'))
                             
                             
           and UserDefineBlck_YEST.BOR_REF_DATA= @BOR_xHistoricalDataSet:N
          -- and UserDefineBlck_YEST.BOR_REF_DATA =48181
        --  and UserDefineBlck_YEST.BOR_REF_DATA=  48257

                
                and
                         STS_YEST.BOR_UserDefineBlck_REF2=UserDefineBlck_YEST.BOR_NB)
  
  -- end Added for bug fix BOR_DF-445 mAY 26TH





UNION ALL

-- Getting all dead trades which got market operated as of today


 -- dead trades logic 
  select
  --TRN.BOR_CBOR_P_TYPO as XX,
  '' as 'Pre-novation ID_Trade',
  '' as 'Common Data Delegated',
  'LEIXYZXYZXYZ' as 'Reporting Firm ID',
  '' as 'Other Counterparty ID',
  '' as 'Other Counterparty ID Type',
  '' as 'Reporting Firm Corporate N.',
  '' as 'Reporting Firm Registered O.',
  '' as 'Reporting Firm Country Co.',
  'F' as 'Reporting Firm Corporate Se.',
  'F' as 'Reporting Firm Financial St.',
  '' as 'Broker ID', 
  '' as 'Broker ID Type',
  '' as 'Submitting Entity ID',
  '' as 'Submitting Entity ID Type',
  '' as 'Clearing BOR_ember ID',
  '' as 'Clearing BOR_ember ID Type',
--JIRA-12 changes
'LEIXYZXYZXYZ' as 'Beneficiary ID',
'L' as 'Beneficiary ID Type',
--END
  'P' as 'Trading Capacity',
  BOR_TP_BUYSELL as 'Buy / Sell Indicator',
  '' as 'Counterparty EEA Status',
  '' as 'Commercial / Treasury Activ.', 
  '' as 'Above Clearing Threshold',
  
--BOR_DF 522
  --cast(round(TRN.BOR_PL_FBOR_V2 + TRN.BOR_PL_FPFCP2 + TRN.BOR_PL_FTFI2 + TRN.BOR_PL_CSFRV2 + TRN.BOR_PL_FPFRV2,2) as numeric(36,2))
  cast(round(TRN.BOR_PL_NFBOR_V2 + TRN.BOR_PL_FPNFCP2 + TRN.BOR_PL_FTFI2 ,2) as numeric(36,2))
  
       as 'BOR_ark to BOR_arket Value',
TRN.BOR_PL_INSCUR  as 'BOR_ark to BOR_arket Currency',
 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),1,4)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),5,2)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),7,2)  as 'Valuation Date',
'23:59:00' as 'Valuation Time',
'BOR_' as 'Valuation Type',
'OC' as 'Collateral Type',
'Y' as 'Collateral Portfolio',
case when CNTR.BOR_PARENT_LBL<>'' THEN '030000'+CNTR.BOR_PARENT ELSE '030000'+BOR_LABEL end as 'Collateral Portfolio Code',
ABS(ISNULL(BOR_LC_COL.BOR_TOTAL_COLL,0)) as 'Collateral Value',
'USD' as 'Collateral Value Currency',
--END  TRADERPT valuation Reporting

  
  
  
  '' as 'Fund BOR_anager ID',
  '' as 'Fund BOR_anager ID Type',
  --JIRA 522 change
'I' as 'Instrument ID Taxonomy', 
--'CO' as 'Instrument ID',
--'XSwapClearLCH'+ 
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end
--+case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
   --  then  'F'
   --  when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' ) 
   --  then  'O'       
   -- else '' 
  --  end
--+case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
    --         then  
      --              case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
     --        else ltrim('') end
--+
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
--case  when TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
 --else  convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 --+ case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
   --      then  
        --      ltrim(str(TRN.BOR_TP_STRIKE))
      --    else ltrim('')
      --   end
as 'Instrument ID',
'' as 'ETD Asset Class ID',
case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future') 
     then  'FCEPSX'
     when  ( TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
     then  'FCEPSX'
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP ='C') 
     then  'OCAFPS'      
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP <>'C') 
     then  'OPAFPS'
     when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP ='C' ) 
     then  'OCXTCS'  
      when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP <>'C' ) 
     then  'OPXTCS' 
    else '' 
    end as 'Instrument Classification',
    --JIRA 522 end

--JIRA 522 change
'NA' as 'Underlying Instrument ID', 

'' as 'Underlying Instrument ID Typ.',
TRN.BOR_TP_NOBOR_CUR as 'Notional Currency 1',  
--JIRA-522 change
'' as 'Notional Currency 2', 

'' as 'Deliverable Currency',

-- added for SwapClearLCHclear change BOR_DF-522 
case when (TRN.BOR_TP_DTESYS<'20140704' or
 -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               -- JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                             -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
       -- JIRA 554 change 
    --when ( TRN.BOR_TP_DTESYS>'20140921'and TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
      --  'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
   
   
      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then 
                  -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID))
              + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
            end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
            --  JIRA 554 case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
                   -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
                end   --added JIRA 554
             
       else  '' end 
--end BOR_DF-522 
     end as 'ID_Trade'
       ,


case when (TRN.BOR_TP_DTESYS<'20140704' 
           -- JIRA 522 live date
or  (TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               -- JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                                    -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)
                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
      -- JIRA 554 change 
    --when ( TRN.BOR_TP_DTESYS>'20140921'and TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
      --  'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
   
      else


-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then 
                    -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
              
            'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
              
              end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
           -- JIRA 554    case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
               -- BOR_DF 554 change for exercise trades issue
               case when (TRN.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
                           
             'E01SwapClearLCHC000'
              + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  TRN.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
               
            end   --added JIRA 554
             
       else  '' end 
--end BOR_DF-522 

       end as 'BOR_iFID Transaction Referenc.',
  
  'XSwapClearLCH' as 'Venue ID',
  --JIRA-12 change
'N' as 'Compression Exercise',
--end
  TRN.BOR_TP_PRICE as 'Price / Rate',
  substring(TRN.BOR_TP_CBOR_IQ0,1,3) as 'Price Notation', 
  TRN.BOR_RW_GL_NOT1 as 'Notional',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end as 'Price BOR_ultiplier',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  --when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end as 'Quantity', 
  -- JIRA 522 change 
case  when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option') then 
cast(  ROUND( TRN.BOR_TP_PRICE *
(  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
--  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end)
*
(case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end),2) 
       as numeric (36,2))

else 0 end       as 'Up Front Payment',
-- end 

TRN.BOR_PL_INSCUR as 'Upfront Payment Currency',
  'P' as 'Delivery Type',
--JIRA-522 latest

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Execution Timestamp',
--JIRA-12 change
 --case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFST  as date),112)
 --when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
  --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Effective Date', 
  case when((case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end)<=(CONVERT(VARCHAR(30),substring(TRN.BOR_TP_DTETRN,1,4)+'-'+substring(TRN.BOR_TP_DTETRN,5,2)+'-'+substring(TRN.BOR_TP_DTETRN,7,2)+'00:00:00')))
then--displaying execution timestamp
(case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
       --substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)
else 
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN  as date),112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)
end)
--displaying effective date
else
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)

end  as 'Effective Date',
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN as date),112)   as 'Effective Date',
 
  case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
-- SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                          --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
                            
 else  
                 --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
  end  
 as 'BOR_aturity Date', --modify

--JIRA522 change
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option'  or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Termination Date',--modify
   --  '' as 'Termination Date',
 case when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA' or TRN.BOR_ABOR_D_STS2='NA' 
 and VER1.BOR_ACT_DATE <> TRN.BOR_EV_DATE_AC)then   
 (case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
     --  substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
else 
  -- CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
  -- case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
  -- else '00:00:00' end,0),23) 
  convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)  
end )
else ''
end as 'Termination Date',
 
 -- case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),112)
    --  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 -- else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
 --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                 convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)              
 else  
                     --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                       --     SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
 
 end  
    as 'Settlement Date',--modify
 '' as 'BOR_aster Agreement',
  '' as 'BOR_aster Agreement Version',
--JIRA-12 change
case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end  as 'Confirmation Timestamp',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'Y' else 'E' end as 'Confirmation Type',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'N' else 
'X' end as 'Clearing Obligation',

'Y' as 'Cleared',
--case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 'Y' else  '' end  as 'Cleared',
--JIRA-522

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else

 CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) end as 'Clearing Timestamp',

--JIRA-12 change end

'213800L8AQD59D3JRW81' as 'CCP ID',
'L' as 'CCP ID type',
  'N' as 'Intragroup',
  '' as 'Fixed Rate Leg 1',
  '' as 'Fixed Rate Leg 2',
  '' as 'Fixed Rate Day Count',
  '' as 'Fixed Leg Payment Frequency',
  '' as 'Floating Rate Payment Freque..',
  '' as 'Floating Rate Reset Frequency',
  '' as 'Floating Rate Leg 1',
  '' as 'Floating Rate Leg 2',
  '' as 'Currency 2',
  '' as 'Exchange Rate 1',
  '' as 'Forward Exchange Rate',
  '' as 'ExchangeRate Basis',
  
--JIRA 522 change 
'' as 'Commodity Base',
'' as 'Commodity Details',
--'BOR_E' as 'Commodity Base',
--'NP' as 'Commodity Details',
  '' as 'Delivery Point',
  '' as 'Interconnection Point',
  '' as 'Load Type',
  '' as 'Delivery Start Timestamp',
  '' as 'Delivery End Timestamp',
  '' as 'Contract Capacity', 
  '' as 'Quantity Unit',
  '' as 'Price Per Time Interval Qu.',
   case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
               then  
                      case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
               else '' end as 'Put / Call', 
               
  
--JIRA522 change           
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' 
             then  
             'A'
          --case when TRN.BOR_TP_AE = 'A' then 'A' 
              -- when TRN.BOR_TP_AE = 'E' then 'E'
                --else 'X'
                --  end 
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then 'S'
       
       else '' end as 'Option Exercise Type',
  case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
           then  
                TRN.BOR_TP_STRIKE
            else 0
           end as 'Strike Price',
  case 
  --when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')   then  ''
  when ( TRN.BOR_ABOR_D_STS2 = 'O' )  then  'N'
  when (TRN.BOR_ABOR_D_STS2='NA' and VER1.BOR_ACT_DATE <> TRN.BOR_EV_DATE_AC) then 'C'
  when ( VER1.BOR_VERSION = 1 and VER2.BOR_VERSION = 1) THEN 'N'  
  when ((VER2.BOR_DESC='Cancel and reissue') and VER1.BOR_VERSION = VER2.BOR_VERSION) then 'N'  
  when ( TRN.BOR_ABOR_D_STS2 = 'CA' or TRN.BOR_ABOR_D_STS2 = 'NA')  then  'C'  
   else 'O'  end as 'Action Type',   
  case when ((TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
             and (TRN.BOR_ABOR_D_STS2 <> 'O' and TRN.BOR_ABOR_D_STS2 <> 'CA' and TRN.BOR_ABOR_D_STS2 <> 'NA' ) 
             and (VER2.BOR_DESC='Exercise') )  then 'EX'
   else ''  end as 'Action Type Details',
    'T' as 'BOR_essage Type',
  '' as 'ETD Indicator',
  '' as 'Notional 2',
  '' as 'PID_Trade',
  LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
  when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
  when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
  else
  'D' end as 'Instrument Description',
  TRN.BOR_CONTRACT as'InternalID',
  CNTR.BOR_LABEL as 'Counterparty ID',
--ADDED FOR DELIGATION REPORT
''  as 'Delegation Type',
'' as 'Counterparty firm financial st',
'' as 'Counterparty Trading capacity',
'' as 'Counterparty corporate sector',
'' as 'Reporting firm EEA status '
--end
  --TRN.BOR_TP_DTESYS as 'sysda',
   --TRN.BOR_STP_STATUS as 'stats',
  --VER1.BOR_DESC V1DIS,
  --VER1.BOR_DESC V2DIS,
  --VER1.BOR_VERSION V1VER,
  -- VER2.BOR_VERSION V2VER,
 -- TRN.BOR_DATE_TODAY,
 -- TRN.BOR_ABOR_D_STS2 amdstatus,
  --TRN.BOR_DATE_TODAY as 'today',
  --VER1.BOR_ACT_DATE V1DTAE,
  --TRN.BOR_EV_DATE_AC EVDATE,
 -- VER2.BOR_ACT_DATE V2DATE
  from  DATABASE.PUBLICDB.CLIENT_STBOR_T_REP TRN,
   DATABASE.PUBLICDB.BBOR_CPDF_REP CNTR , 
  -- TABLE#DATA#DEALCOBOR_DBF DEAL_COBOR_,
 DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP DEAL_COBOR_,
  DATABASE.PUBLICDB. BBOR_CLIENT_ST_REP BOR_LC_COL,
  (select
  EXT.BOR_VERSION,
  EXT.BOR_TRADE_REF,
  EXT.BOR_ORIG_TRADE,
  EXT.BOR_UserDefineBlck_REF,
  EXT.BOR_ACT_DATE,
  EXT.BOR__DT_TS,
  CLS.BOR_DESC
  from
  DATABASE.PUBLICDB. BBOR_TRN_EXT_REP EXT,  DATABASE.PUBLICDB.BBOR_EVT_EVENT_REP EVT, DATABASE.PUBLICDB.BBOR_CLASS_BOR_APPING_REP CLS
  where
  EXT.BOR_EVT_REF *= EVT.BOR_REFERENCE and EVT.BOR__INTID_ *= CLS.BOR_ID
  ) VER1,
  (select
  EXT.BOR_VERSION,
  EXT.BOR_TRADE_REF,
  EXT.BOR_ORIG_TRADE,
  EXT.BOR_UserDefineBlck_REF,
  EXT.BOR_ACT_DATE,
  EXT.BOR__DT_TS,
  CLS.BOR_DESC
  from
  DATABASE.PUBLICDB. BBOR_TRN_EXT_REP EXT,  DATABASE.PUBLICDB.BBOR_EVT_EVENT_REP EVT,  DATABASE.PUBLICDB.BBOR_CLASS_BOR_APPING_REP CLS
  where
  EXT.BOR_EVT_REF *= EVT.BOR_REFERENCE and EVT.BOR__INTID_ *= CLS.BOR_ID) VER2
  
  Where
  TRN.BOR_NB=VER1.BOR_TRADE_REF  
  and VER1.BOR_ORIG_TRADE=VER2.BOR_ORIG_TRADE
  -- excluding expiry trades
  and ((VER1.BOR_VERSION=VER2.BOR_VERSION and (LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) = null or LTRIBOR_(RTRIBOR_(VER2.BOR_DESC))  <> 'Expiry')) 
        or (VER1.BOR_VERSION+1=VER2.BOR_VERSION and  ((LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) <> 'Expiry') and (LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) <> 'Cancel') and (LTRIBOR_(RTRIBOR_(VER2.BOR_DESC)) <> 'Exercise')) ))
  
 and (
     ((VER1.BOR_ACT_DATE = convert(DATE,TRN.BOR_DATE_TODAY) ) and (VER2.BOR_ACT_DATE = convert(DATE,TRN.BOR_DATE_TODAY)) )
      or (VER1.BOR_VERSION=1 and VER2.BOR_VERSION=1 and TRN.BOR_ABOR_D_STS2='NA' and VER1.BOR_ACT_DATE <>TRN.BOR_EV_DATE_AC )
    )                          
  
  and TRN.BOR_TP_CNTRP=CNTR.BOR_DSP_LABEL
  and TRN.BOR_UserDefineBlck_REF2=DEAL_COBOR_.BOR_NB
  and  case when CNTR.BOR_PARENT_LBL<>'' 
                   THEN CNTR.BOR_PARENT_LBL 
--                    ELSE CNTR.BOR_DSP_LABEL end *= ltrim(rtrim(SUBSTRING(BOR_LC_COL.BOR_CTP,1,patindex('%##%',BOR_LC_COL.BOR_CTP)-1)))
       ELSE CNTR.BOR_DSP_LABEL end *= LTRIBOR_(RTRIBOR_(BOR_LC_COL.BOR_CTP))  
  and TRN.BOR_TP_STATUS2 = 'DEAD'
  and TRN.BOR_STP_STATUS<>'Csubmit' and TRN.BOR_STP_STATUS<>'BOR_SubmitTimed' and TRN.BOR_STP_STATUS<>'BOR_SubmitUntimed' and TRN.BOR_STP_STATUS<>'Unmatched'
  and  TRN.BOR_STP_STATUS<>'ProblemQry' and TRN.BOR_STP_STATUS<>'Pending_FO' and TRN.BOR_STP_STATUS<>'Rejected'
  and(TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry' or
  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
  and TRN.BOR_TP_INT = 'N'
  and TRN.BOR_ABOR_D_STS2 <> 'OA'
  and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_REGIST))='YES' 
  and ( LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))<>'' or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID)) <>null or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')
  and DEAL_COBOR_.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='UserDefineBlck_DEALCOBOR_.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'UserDefineBlck_COBOR_DEAL')
-- ADDED FOR SEGRIGATE Account CHANGE
--and (LTRIBOR_(RTRIBOR_(TRN.BOR_CNTLEVTL2))=null  or LTRIBOR_(RTRIBOR_(TRN.BOR_CNTLEVTL2))<>'Cancel and reinsert')
--END

-------------------------------------
-------------------------------------
-------------------------------------
-------------------------------------
-------------------------------------




------------------------------------------------------------------------------------
--- BE_TRADERPT_ETDVALU ---  OUTPUT FILE NABOR_E --> "TRADERPT_ETD_SBANKbank_Valuation.csv"
------------------------------------------------------------------------------------



 --Ruth
 select 
--TRN.BOR_CBOR_P_TYPO as XX,
'' as 'Pre-novation ID_Trade',
'' as 'Common Data Delegated',
'LEIXYZXYZXYZ' as 'Reporting Firm ID',
'' as 'Other Counterparty ID',
'' as 'Other Counterparty ID Type',
'' as 'Reporting Firm Corporate N.',
'' as 'Reporting Firm Registered O.',
'' as 'Reporting Firm Country Co.',
'F' as 'Reporting Firm Corporate Se.',
'F' as 'Reporting Firm Financial St.',
'' as 'Broker ID', 
'' as 'Broker ID Type',
'' as 'Submitting Entity ID',
'' as 'Submitting Entity ID Type',
'' as 'Clearing BOR_ember ID',
'' as 'Clearing BOR_ember ID Type',
--JIRA-12 changes
'LEIXYZXYZXYZ' as 'Beneficiary ID',
'L' as 'Beneficiary ID Type',
--END
'P' as 'Trading Capacity',
BOR_TP_BUYSELL as 'Buy / Sell Indicator',
'' as 'Counterparty EEA Status',
'' as 'Commercial / Treasury Activ.', 
'' as 'Above Clearing Threshold',
     
  --cast(round(TRN_PL.BOR_PL_FBOR_V2 + TRN_PL.BOR_PL_FPFCP2 + TRN_PL.BOR_PL_FTFI2 ,2) as numeric(36,2))
  cast(round(TRN_PL.BOR_PL_NFBOR_V2 + TRN_PL.BOR_PL_FPNFCP2 + TRN_PL.BOR_PL_FTFI2 ,2) as numeric(36,2))
     -- TRN_PL.BOR_PL_CSFRV2 + TRN_PL.BOR_PL_FPFRV2  
       as 'BOR_ark to BOR_arket Value',
TRN.BOR_PL_INSCUR  as 'BOR_ark to BOR_arket Currency',
 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),1,4)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),5,2)+'-'+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_DATE_TODAY as date),112),7,2)  as 'Valuation Date',
'23:59:00' as 'Valuation Time',
'BOR_' as 'Valuation Type',
'OC' as 'Collateral Type',
'Y' as 'Collateral Portfolio',
case when CNTR.BOR_PARENT_LBL<>'' THEN '030000'+CNTR.BOR_PARENT ELSE '030000'+BOR_LABEL end as 'Collateral Portfolio Code',
ABS(ISNULL(BOR_LC_COL.BOR_TOTAL_COLL,0)) as 'Collateral Value',
'USD' as 'Collateral Value Currency',
--END  TRADERPT valuation Reporting

'' as 'Fund BOR_anager ID',
'' as 'Fund BOR_anager ID Type',

--JIRA 522 change
--'A' as 'Instrument ID Taxonomy', 
'I' as 'Instrument ID Taxonomy', 
--'CO' as 'Instrument ID',
--'XSwapClearLCH'+ 
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end
--+case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
   --  then  'F'
  --   when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' ) 
   --  then  'O'       
   -- else '' 
  --  end
--+case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
        --     then  
        --            case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
        --     else ltrim('') end
--+

--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
--case  when TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then  convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
-- else  convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
-- + case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
      --   then  
        --      ltrim(str(TRN.BOR_TP_STRIKE))
        --  else ltrim('')
      --   end
as 'Instrument ID',
'' as 'ETD Asset Class ID',
case when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future') 
     then  'FCEPSX'
     when  ( TRN.BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry') 
     then  'FCEPSX'
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP ='C') 
     then  'OCAFPS'      
     when  (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' and  TRN.BOR_TP_CP <>'C') 
     then  'OPAFPS'
     when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP ='C' ) 
     then  'OCXTCS'  
      when  ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' and TRN.BOR_TP_CP <>'C' ) 
     then  'OPXTCS' 
    else '' 
    end as 'Instrument Classification',
    --JIRA 522 end

--JIRA 522 change
'NA' as 'Underlying Instrument ID', 

'' as 'Underlying Instrument ID Typ.',
TRN.BOR_TP_NOBOR_CUR as 'Notional Currency 1',  
--JIRA-522 change
'' as 'Notional Currency 2', 

'' as 'Deliverable Currency',



---####
-- added for SwapClearLCHclear change BOR_DF-522 
case when (TRN.BOR_TP_DTESYS<'20140704' or
   -- JIRA 522 live date
(TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
          --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
-- case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
                                       -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140702' and TRN.BOR_TP_DTESYS<'20140922') then

-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)

                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),7,2)

                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)

                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT   as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT   as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),7,2)

                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
  -- when ( TRN.BOR_TP_DTESYS>'20140921'and SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='' ) then 
     --   'XE01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
   
      else

-- new uti logic
-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
              
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               
               else 
              -- end
              
            'E01SwapClearLCHC000'
            +   LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            --LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
             + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
             
             end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
                  -- BOR_DF 554 change      case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
             
              -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
              
             'E01SwapClearLCHC000'
            + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
             --LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
             + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
             
             end --added JIRA 554
             
       else  '' end 
--end BOR_DF-522 
     end as 'ID_Trade'
       ,

--- ###

case when (TRN.BOR_TP_DTESYS<'20140704' or 
          -- JIRA 522 live date
    (TRN.BOR_TP_DTESYS<'20140922' and (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')) )
then
'000XLCH000'+ convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
                 --JIRA 522 live date minus 1
 when ( TRN.BOR_TP_DTESYS>'20140921' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem') then
'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10) 
-- case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
                                            -- JIRA 522 live date
 when (TRN.BOR_TP_DTESYS>'20140703' and TRN.BOR_TP_DTESYS<'20140922') then
-- ID_Trade OLD logic 
  case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+
              LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
                     case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                                 SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                            when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)

                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),7,2)


                            else
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                                  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                            end
                +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))                  
                               
                   + BOR_TP_BUYSELL  
                   
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then  '000XLCH000'+convert(CHAR(8),cast(TRN.BOR_TP_DTETRN as date),112)+ 
             LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID,PATINDEX('%[^0]%',DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID),CHAR_LENGTH(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))     ))+
            
             case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),1,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),4,2)+
                            SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),03),7,2)
                
              when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),1,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),4,2)+
--                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),3),7,2)

                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),1,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),4,2)+
                                          SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_CBOR_CBOR_AT  as date),3),7,2)

                   else
                   
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),1,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),4,2)+
                    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),3),7,2)
                    end
                   
                   +
                    LTRIBOR_(RTRIBOR_(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25), 1,  CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) - 1  )))+
                 LTRIBOR_(RTRIBOR_(reverse(SUBSTRING(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25))))
                   ,PATINDEX('%[^0]%',reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ,CHAR_LENGTH(reverse(SUBSTRING(str(ROUND(TRN.BOR_TP_PRICE,2),50,25),CHARINDEX('.',str(ROUND(TRN.BOR_TP_PRICE,2),50,25)) + 1,CHAR_LENGTH(str(ROUND(TRN.BOR_TP_PRICE,2),50,25)))))
                   ))
                   ))    
                   +
                   
                   BOR_TP_BUYSELL
             
       else  '' end 
       
   ---End for TRN.BOR_TP_DTESYS>'20140702' 
   
     else

-- New ID_Trade logic
-- added for SwapClearLCHclear change BOR_DF-522 

case  when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) 
              or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))='LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%') )
             then  
             
               -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
            'E01SwapClearLCHC000'
            + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            --LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
              + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end

               end   --added JIRA 554
                                
          when ( (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER))=null) or (LTRIBOR_(RTRIBOR_(TRN.BOR_TP_CNTRP))<>'LCH' and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) NOT LIKE '%COPY%'))
             then  'E02'+'LEIXYZXYZXYZ'+CAST(TRN.BOR_CONTRACT as VARCHAR(10))
             -- BOR_DF 554     case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
      
         when   (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%COPY%')
             then 
             
                 -- BOR_DF 554 change for exercise trades issue
               case when (SNAP_ADD.BOR_CNT_EVTL='Exercise' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID<>'' and DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO='')
               then 'E01SwapClearLCHC000'+RIGHT(REPLICATE('0',10)+CAST(TRN.BOR_CONTRACT as VARCHAR(10)),10)
               else 
              -- end
             
             'E01SwapClearLCHC000'
             + LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_REFNO))
            -- LTRIBOR_(RTRIBOR_(SUBSTRING(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)))+RIGHT(REPLICATE('0',8)+CAST(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID as VARCHAR(8)),8)
             +LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TSLID)) 
             + case when  SNAP_ADD.BOR_CNT_EVTL='Exercise' then 'E' else LTRIBOR_('') end
             
                end   --added JIRA 554
                
       else  '' end 
--end BOR_DF-522 

       end as 'BOR_iFID Transaction Referenc.',

'XSwapClearLCH' as 'Venue ID',
--JIRA-12 change
'N' as 'Compression Exercise',
--end
TRN.BOR_TP_PRICE as 'Price / Rate',
substring(TRN.BOR_TP_CBOR_IQ0,1,3) as 'Price Notation', 
TRN.BOR_RW_GL_NOT1 as 'Notional',
case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end as 'Price BOR_ultiplier',
  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end as 'Quantity', 
  
case  when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option') then 
cast(  ROUND( TRN.BOR_TP_PRICE *
(  case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') then TRN.BOR_OI_LOT_SZ
  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry') then TRN.BOR_TP_LQTY2
  else  convert(NUBOR_ERIC(20,3), TRN.BOR_TP_IQTY) end)
*
(case  when (TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Carry')
             then  TRN.BOR_RW_LOT_SZ
             
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then TRN.BOR_COBOR_LOT
      
       else 1 end),2) 
       as numeric (36,2))

else 0 end       as 'Up Front Payment',
-- end 

TRN.BOR_PL_INSCUR as 'Upfront Payment Currency',
'P' as 'Delivery Type',
case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Execution Timestamp',
case when((case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end)<=(CONVERT(VARCHAR(30),substring(TRN.BOR_TP_DTETRN,1,4)+'-'+substring(TRN.BOR_TP_DTETRN,5,2)+'-'+substring(TRN.BOR_TP_DTETRN,7,2)+'00:00:00')))
then--displaying execution timestamp
(case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,8)
--convert(varchar(30),DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,112)
     --  substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)
else 
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
--convert(CHAR(10),cast(TRN.BOR_TP_DTETRN  as date),112)
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)
end)
--displaying effective date
else
--substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),1,4)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),5,2)+'-'+substring(convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112),7,2)
convert(VARCHAR(30),TRN.BOR_TP_DTETRN,112)
end as 'Effective Date',
 
  case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
-- SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                          --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)
                            
 else  
                 --  SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                            convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
  end  
 as 'BOR_aturity Date', --modify

--JIRA522 change
--case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option'  or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 --else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end as 'Termination Date',--modify
  '' as 'Termination Date',
 
 -- case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then  convert(CHAR(10),cast(TRN.BOR_TP_RTDPC02 as date),112)
    --  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' then  convert(CHAR(10),cast(TRN.BOR_TP_RTBOR_AT0  as date),112)
 -- else convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112) end
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then 
 --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),1,4)+'-'+
                        --    SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112),7,2)
                 convert(CHAR(10),cast(TRN.BOR_TP_DTEFXGL  as date),112)              
 else  
                     --SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),1,4)+'-'+
                       --     SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),5,2)+'-'+
                         --   SUBSTRING(convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112),7,2)
                convert(CHAR(10),cast(TRN.BOR_TP_DTEEXP  as date),112)
 
 end  
    as 'Settlement Date',--modify
 
'' as 'BOR_aster Agreement',
'' as 'BOR_aster Agreement Version',
--JIRA-12 change
case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
       substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 
   CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23) 
end as 'Confirmation Timestamp',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'Y' else 'E' end as 'Confirmation Type',

 case when  (LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_TRADERPTBOR_ASTER)) LIKE '%ORIGINAL%')
             then 'N' else 
'X' end as 'Clearing Obligation',

'Y' as 'Cleared',
--case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 'Y' else  '' end  as 'Cleared',
--JIRA-522

case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E))<>'' then 
substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,1,4)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,5,2)+'-'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,7,2)+'T'+substring(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TTIBOR_E,10,8) 
else 

 CONVERT(VARCHAR(30),CONVERT(datetime,substring(TRN.BOR_TP_DTETRN,1,11)+' '+
   case when LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E))<>'' then substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,1,2)+':'+substring(DEAL_COBOR_.BOR_SwapClearLCH_TIBOR_E,3,2)+':00'
   else '00:00:00' end,0),23)
end as 'Clearing Timestamp',

--JIRA-12 change end

--BOR_DF522
'213800L8AQD59D3JRW81' as 'CCP ID',

'L' as 'CCP ID type',
'N' as 'Intragroup',
'' as 'Fixed Rate Leg 1',
'' as 'Fixed Rate Leg 2',
'' as 'Floating Rate Payment Freque..',
'' as 'Fixed Rate Day Count',
'' as 'Fixed Leg Payment Frequency',
'' as 'Floating Rate Reset Frequency',
'' as 'Floating Rate Leg 1',
'' as 'Floating Rate Leg 2',
'' as 'Currency 2',
'' as 'Exchange Rate 1',
'' as 'Forward Exchange Rate',
'' as 'ExchangeRate Basis',

--JIRA 522 change 
'' as 'Commodity Base',
'' as 'Commodity Details',
--'BOR_E' as 'Commodity Base',
--'NP' as 'Commodity Details',

'' as 'Delivery Point',
'' as 'Interconnection Point',
'' as 'Load Type',
'' as 'Delivery Start Timestamp',
'' as 'Delivery End Timestamp',
'' as 'Contract Capacity', 
'' as 'Quantity Unit',
'' as 'Price Per Time Interval Qu.',
 case when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' 
             then  
                    case when TRN.BOR_TP_CP ='C' then 'C' else 'P' end 
             else '' end as 'Put / Call', 

--JIRA522 change           
 case  when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' 
             then  
             'A'
          --case when TRN.BOR_TP_AE = 'A' then 'A' 
              -- when TRN.BOR_TP_AE = 'E' then 'E'
                --else 'X'
                --  end 
       when  TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO' then 'S'
       
       else '' end as 'Option Exercise Type',
       
case when ( TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or   TRN.BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO') 
         then  
              TRN.BOR_TP_STRIKE
          else 0
         end as 'Strike Price',
     --    TRN.BOR_ABOR_D_STS2 as STTXXXXXX,
'V'  as 'Action Type',   
 --added OA sts bug fix
''  as 'Action Type Details',
 --end
'T' as 'BOR_essage Type',
'' as 'ETD Indicator',
'' as 'Notional 2',
'' as 'PID_Trade',
LTRIBOR_(RTRIBOR_(TRN.BOR_COBOR_BOR_CODE))+ case when TRN.BOR_TP_NOBOR_CUR = 'EUR' then 'E'
when TRN.BOR_TP_NOBOR_CUR = 'JPY' then 'Y'
when TRN.BOR_TP_NOBOR_CUR = 'GBP' then 'S'
else
'D' end as 'Instrument Description',
TRN.BOR_CONTRACT as'InternalID',
CNTR.BOR_LABEL as 'Counterparty ID',
--ADDED FOR DELIGATION REPORT
''  as 'Delegation Type',
'' as 'Counterparty firm financial st',
'' as 'Counterparty Trading capacity',
'' as 'Counterparty corporate sector',
'' as 'Reporting firm EEA status '

from (select * from  DATABASE.PUBLICDB.BBOR_RISK_REP where BOR_TP_DTESYS < BOR_DATE_TODAY 
and BOR_TP_STATUS2 <> 'DEAD'
and BOR_STP_STATUS<>'Csubmit' and BOR_STP_STATUS<>'BOR_SubmitTimed' and BOR_STP_STATUS<>'BOR_SubmitUntimed' and BOR_STP_STATUS<>'Unmatched'
and  BOR_STP_STATUS<>'ProblemQry' and BOR_STP_STATUS<>'Pending_FO' and  BOR_STP_STATUS<>'Rejected'
and(BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Future' or BOR_CBOR_P_TYPO= 'COBOR_: SwapClearLCH Exch Carry' or
BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch Option' or BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO')
and BOR_TP_INT = 'N'
-- JIRA 810 exclude matured trades bug fix
and (case  when BOR_CBOR_P_TYPO = 'COBOR_: SwapClearLCH Exch TAPO'  then BOR_TP_DTEFXGL end  > BOR_DATE_TODAY or
 case when  BOR_CBOR_P_TYPO <> 'COBOR_: SwapClearLCH Exch TAPO'  then  BOR_TP_DTEEXP end > BOR_DATE_TODAY )
-- JIRA 810 end 
and BOR_REF_DATA=(select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_RISK.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_RISK')) TRN,
 DATABASE.PUBLICDB.BBOR_CPDF_REP CNTR ,  DATABASE.PUBLICDB.BBOR_SNAP_ADD_REP SNAP_ADD

-- JIRA 522 change
,(select * from  DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP where BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='UserDefineBlck_DEALCOBOR_.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'UserDefineBlck_COBOR_DEAL')) DEAL_COBOR_
,(select * from  DATABASE.PUBLICDB.BBOR_RISK_PL_REP where BOR_REF_DATA=(select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_RISK_PL.REP' 
                                                                              and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_RISK'))  TRN_PL
,  DATABASE.PUBLICDB.BBOR_CLIENT_ST_REP BOR_LC_COL
where  TRN.BOR_TP_CNTRP=CNTR.BOR_DSP_LABEL
and TRN.BOR_NB =  SNAP_ADD.BOR_NB
and TRN.BOR_NB =  TRN_PL.BOR_NB
and SNAP_ADD.BOR_UserDefineBlck_REF2=DEAL_COBOR_.BOR_NB
AND  case when CNTR.BOR_PARENT_LBL<>'' 
                   THEN CNTR.BOR_PARENT_LBL
--                  ELSE CNTR.BOR_DSP_LABEL end *= ltrim(rtrim(SUBSTRING(BOR_LC_COL.BOR_CTP,1,patindex('%##%',BOR_LC_COL.BOR_CTP)-1)))
                    ELSE CNTR.BOR_DSP_LABEL end *= LTRIBOR_(RTRIBOR_(BOR_LC_COL.BOR_CTP))                    

and LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_REGIST))='YES'
and ( LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID))<>'' or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_SwapClearLCH_BOR_TID)) <>null or  LTRIBOR_(RTRIBOR_(DEAL_COBOR_.BOR_BNS_SOURCE))= 'ExecSystem')
--AND (TRN.BOR_CONTRACT=569270 or TRN.BOR_CONTRACT=569271 or TRN.BOR_CONTRACT=569272)
--AND (TRN.BOR_CONTRACT=590193 )-- fastfill
     --or TRN.BOR_CONTRACT=468388 or TRN.BOR_CONTRACT=468389)


-- excluding trades which were in invalid status yesterday and got validated today
and TRN.BOR_NB NOT IN (select STS_YEST.BOR_NB from

                        (select * from  DATABASE.PUBLICDB.BBOR_STATUS_REP where BOR_DATE_TODAY= 
                                          (select BOR_AX(BOR_DATE_YEST) from  DATABASE.PUBLICDB.BBOR_STATUS_REP BBOR_STAS_INNER
                                                where BBOR_STAS_INNER.BOR_REF_DATA= (select max(BOR_REF_DATA) from  DATABASE.PUBLICDB.DYN_AUDIT_REP where BOR_OUTPUTTBL ='BBOR_STATUS.REP' 
                                                      and BOR_DELETED='N' and BOR_TAG_DATA = 'BBOR_STATUS')) ) STS_YEST,
                                (select * from  DATABASE.PUBLICDB.UserDefineBlck_DEALCOBOR_REP where 
                              BOR_REF_DATA= @BOR_xHistoricalDataSet:N  
                             -- BOR_REF_DATA=  43758
                           --  BOR_REF_DATA= 48257
                                ) UserDefineBlck_YEST
                       
                     where 
                
                             (
                              (  ( LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))='ExecSystem') and 
                                (STS_YEST.BOR_STP_STATUS='Csubmit' or STS_YEST.BOR_STP_STATUS='BOR_SubmitTimed' or STS_YEST.BOR_STP_STATUS='BOR_SubmitUntimed' or
                                 STS_YEST.BOR_STP_STATUS='Unmatched'  or    STS_YEST.BOR_STP_STATUS='ProblemQry'  or STS_YEST.BOR_STP_STATUS='Pending_FO' or STS_YEST.BOR_STP_STATUS='Rejected') 
                              ) 
                       or                         
                          (  (LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))<> 'ExecSystem' or LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_BNS_SOURCE))= NULL) and 
                                (STS_YEST.BOR_STP_STATUS='Csubmit' or STS_YEST.BOR_STP_STATUS='BOR_SubmitTimed' or STS_YEST.BOR_STP_STATUS='BOR_SubmitUntimed' or
                               STS_YEST.BOR_STP_STATUS='Unmatched'  or    STS_YEST.BOR_STP_STATUS='ProblemQry'  or STS_YEST.BOR_STP_STATUS='Pending_FO' or STS_YEST.BOR_STP_STATUS='Rejected'
                                or  LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_SwapClearLCH_BOR_TID))='' or  LTRIBOR_(RTRIBOR_(UserDefineBlck_YEST.BOR_SwapClearLCH_BOR_TID)) =null )
                            )
                          )
                                    

                and
                      sTS_YEST.BOR_UserDefineBlck_REF2=UserDefineBlck_YEST.BOR_NB)
