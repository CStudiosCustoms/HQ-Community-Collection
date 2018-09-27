--D/D/D Immortal Wolf of Abyssal Darkness
function c121214.initial_effect(c)
  --Pendulum Summon
  aux.EnablePendulumAttribute(c)
  --(1) Change Lvl
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(121214,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCountLimit(1)
  e1:SetRange(LOCATION_PZONE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c121214.lvtg)
  e1:SetOperation(c121214.lvop)
  c:RegisterEffect(e1)
  --(2) Gain LP instead 1
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_REVERSE_DAMAGE)
  e2:SetRange(LOCATION_PZONE)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetTargetRange(1,0)
  e2:SetValue(c121214.rev)
  c:RegisterEffect(e2)
  --(3) Take control
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(121214,1))
  e3:SetCategory(CATEGORY_CONTROL)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e3:SetCountLimit(1,121214)
  e3:SetTarget(c121214.tctg)
  e3:SetOperation(c121214.tcop)
  c:RegisterEffect(e3)
  --(4) Gain LP instead 2
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD)
  e4:SetCode(EFFECT_REVERSE_DAMAGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetTargetRange(1,0)
  e4:SetValue(c121214.rev)
  c:RegisterEffect(e4)
end
--(1) Change Lvl
function c121214.filter(c)
  return c:IsFaceup() and c:IsSetCard(0xaf) and c:GetLevel()>0
end
function c121214.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c121214.filter(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c121214.filter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c121214.filter,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
  local lv=Duel.AnnounceLevel(tp,1,8,g:GetFirst():GetLevel())
  Duel.SetTargetParam(lv)
end
function c121214.lvop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
  if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LEVEL)
    e1:SetValue(lv)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
  end
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetTargetRange(1,0)
  e2:SetTarget(c121214.splimit)
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
end
function c121214.splimit(e,c)
  return not c:IsSetCard(0xaf)
end
--(2) Gain LP instead
function c121214.rev(e,re,r,rp,rc)
  return bit.band(r,REASON_EFFECT)~=0
end
--(3) Take control
function c121214.tctg(e,tp,eg,ep,ev,re,r,rp,chk)
  local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
  if chk==0 then return #g>0 end
  Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c121214.tcop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
  local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
  if #g>0 then
  	Duel.HintSelection(g)
  	Duel.GetControl(g,tp)
  end
  --(3.1) Half battle damage
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e1:SetCondition(c121214.damcon)
  e1:SetOperation(c121214.dop)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
end
--(3.1) Half battle damage
function c121214.damcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp
end
function c121214.dop(e,tp,eg,ep,ev,re,r,rp)
  Duel.HalfBattleDamage(ep)
end