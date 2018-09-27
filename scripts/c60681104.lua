--Number 256: Neo Divine Dragon Lord Felgrand
function c60681104.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),8,3,c60681104.ovfilter,aux.Stringid(60681104,1))
    --Reveal
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60681104,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c60681104.atkcon)
    e1:SetTarget(c60681104.atktg)
    e1:SetOperation(c60681104.atkop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(c60681104.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --multiple attack/special summon
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e3:SetDescription(aux.Stringid(60681104,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c60681104.deccost)
    e3:SetTarget(c60681104.dectg)
    e3:SetOperation(c60681104.decop)
    c:RegisterEffect(e3)
end
c60681104.xyz_number=256
function c60681104.ovfilter(c)
    return c:IsFaceup() and c:IsCode(1639384)
end
--Reveal
function c60681104.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.IsCode,1,nil,60681103) or g:IsExists(Card.IsCode,1,nil,1639384) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c60681104.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c60681104.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local h1=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
        if e:GetHandler():IsLocation(LOCATION_EXTRA) then h1=h1-1 end
        local h2=Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)
        return (h1>0 and h2>0)
    end
end
function c60681104.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
    local g2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g1)
    Duel.ConfirmCards(tp,g2)
    local atpsl=g1:GetFirst()
    local ntpsl=g2:GetFirst()
    local atk=0
    local atk1=0
    if atpsl:IsType(TYPE_XYZ) then
      atk=atpsl:GetRank()
    elseif atpsl:IsType(TYPE_FUSION+TYPE_SYNCHRO) then
      atk=atpsl:GetLevel()
    end
    if ntpsl:IsType(TYPE_XYZ) then
      atk1=ntpsl:GetRank()
    elseif ntpsl:IsType(TYPE_FUSION+TYPE_SYNCHRO) then
      atk1=ntpsl:GetLevel()
    end
    if atk>atk1 then atk,atk1=atk1,atk end
    if c:IsFaceup() and c:IsRelateToEffect(e) then
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(atk1*300)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
      c:RegisterEffect(e1)
      local e2=e1:Clone()
      e2:SetCode(EFFECT_UPDATE_DEFENSE)
      c:RegisterEffect(e2)
    end
end
--multiple attack/special summon
function c60681104.filter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60681104.filter2(c)
  return c:IsRace(RACE_DRAGON) and c:IsLevelAbove(7) and c:IsAbleToGrave()
end
function c60681104.deccost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60681104.dectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    local ac=Duel.AnnounceCard(1-tp,TYPE_MONSTER+RACE_DRAGON)
    Duel.SetTargetParam(ac)
    Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c60681104.decop(e,tp,eg,ep,ev,re,r,rp)
    local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    local c=e:GetHandler()
    c:SetHint(CHINT_CARD,ac)
    local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
    if g:IsExists(Card.IsCode,1,nil,ac) then
        local g=Duel.SelectMatchingCard(tp,c60681104.filter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
    end
    elseif not g:IsExists(Card.IsCode,1,nil,ac) then
        local g=Duel.SelectTarget(tp,c60681104.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        end
    end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
end