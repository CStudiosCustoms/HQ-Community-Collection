--Raidraptor - Base Falcon
--Scripted by Raivost
function c66296401.initial_effect(c)
  --Link Summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba),2)
  c:EnableReviveLimit()
  --(1) Special SUmmon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(66296401,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1,66296401)
  e1:SetTarget(c66296401.sptg)
  e1:SetOperation(c66296401.spop)
  c:RegisterEffect(e1)
  --(2) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(66296401,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,66296401)
  e2:SetTarget(c66296401.thtg)
  e2:SetOperation(c66296401.thop)
  c:RegisterEffect(e2)
end
function c66296401.spfilter(c,e,tp,zone)
  return c:IsSetCard(0xba) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c66296401.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
  if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
  and Duel.IsExistingTarget(c66296401.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c66296401.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCountFromEx(tp)<=0 then return end
  local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c66296401.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
  if g:GetCount()>0 and zone~=0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
  end
end
--(2) Search
function c66296401.thfilter(c)
  return c:IsType(TYPE_SPELL) and c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c66296401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c66296401.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c66296401.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c66296401.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end