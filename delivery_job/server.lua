local moneyForOneDelivery = 10 -- Деньги за одну доставку

-- Coords {-2671,260,5}
local onJobMarker = createMarker(-2671, 260, 3.5, 'cylinder', 2.0, 255, 0, 0, 150)

-- Coords {-2663,240,5}
local stockMarker = createMarker(-2663, 240, 3.5, 'cylinder', 2.0, 255, 0, 0, 150)

-- Маркеры доставки
local deliveryMarkers = {
  {-2051,-406,39},
  {-2152,-434,36},
  {-2147,-424,36},
  {-2336,-166,36},
  {-2430,-146,36},
  {-2431,-182,36}
}

-- Функция для маркера смен
local function jobMarkerHit(player)
  if player then -- А может что то потерялось? Нужно проверить
    if getElementData(player,"delivery_job") == false then -- А ты уже курьер?
      setElementData(player,"delivery_job",true) -- Ты становишься доставщиком
      setElementData(player,"deliveryMoney",0) -- Устанавливаем дефолтное значение
      outputChatBox ("Вы устроились на работу доставщика.", player, 0, 255, 0, true)
    else
      local money = getElementData(player,"deliveryMoney") -- Получаем деньги
      outputChatBox ("Вы заработали "..money.." $", player, 0, 255, 0, true)
      outputChatBox ("Вы уволились с работы доставщика.", player, 255, 0, 0, true)
      setElementData(player,"delivery_job",false) -- Увольняемся
      givePlayerMoney(player, money) -- Выдаем деньги
      setElementData(player,"deliveryMoney",0) -- Обнуляем значение (На всякий случай)
    end
  end
end

-- Функция для маркера доставки
local function deliveryMarkerHit(player)
  if player then -- А может что то потерялось? Нужно проверить
    if getElementData(player,"delivery_job") == true then -- На всякий случай.
      local blip = getElementData(player,tostring(source))
      destroyElement(source) -- Удаляем маркер
      destroyElement(blip) -- Удаляем блип
      local currentMoney = getElementData(player,"deliveryMoney") -- Получаем деньги
      setElementData(player,"deliveryMoney",currentMoney+moneyForOneDelivery) -- Обновляем значение
      outputChatBox ("Посылка доставлена.", player, 0, 255, 0, true )
    else
      outputChatBox ("Вы не работаете доставщиком.", player, 255, 0, 0, true )
    end
  end
end

-- Функция для маркера склада
local function stockMarkerHit(player)
  if player then -- А может что то потерялось? Нужно проверить
    if getElementData(player,"delivery_job") == true then -- Доступ только для избранных (Проверяем тип на всякий случай)
      outputChatBox ("Вы получили посылку.", player, 0, 255, 0, true )
      local markersIds = {} -- Массив с маркерами(чтобы не повторялись), на тот момент лучше идеи мне в голову не приходило
      for i=1,3 do -- 3 маркера
        local random = math.random(1,#deliveryMarkers) -- Обьявляем переменную, мб с первого раза повезет
        repeat
          random = math.random(1,#deliveryMarkers) -- Перебираем
        until not markersIds[random] -- Чекаем есть ли такая позиция уже, если
        markersIds[random] = true -- Мы выбрали этот маркер
        local markerPos = deliveryMarkers[random] -- Выбираем чтобы было удобнее
        local deliveryMarker = createMarker(markerPos[1], markerPos[2], markerPos[3], 'cylinder', 2.0, 255, 0, 0, 150, player) -- Создаем маркер
        local deliveryBlip = createBlipAttachedTo(deliveryMarker, 0) -- Создаем блип
        setElementData(player,tostring(deliveryMarker),deliveryBlip) -- Обновляем значение (Для удаления)
        addEventHandler("onMarkerHit", deliveryMarker, deliveryMarkerHit) -- Ивент захода на маркер
      end
    else
      outputChatBox ("Вы не работаете доставщиком.", player, 255, 0, 0, true )
    end
  end
end

addEventHandler("onMarkerHit", onJobMarker, jobMarkerHit) -- attach onMarkerHit event to MarkerHit function
addEventHandler("onMarkerHit", stockMarker, stockMarkerHit) -- attach onMarkerHit event to MarkerHit function
