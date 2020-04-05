function CCR:CreateFont(name, size, weight, add)
  local tbl = {
    font = "Roboto",
    size = size,
    weight = weight or 500
  }

  if add then
    for k, v in pairs(add) do
      tbl[k] = v
    end
  end

  surface.CreateFont(name, tbl)
end

for i = 1, 100 do
  CCR:CreateFont("CCR." .. i, i, 0)
  CCR:CreateFont("CCR." .. i .. ".MEDIUM", i, 600)
  CCR:CreateFont("CCR." .. i .. ".BOLD", i, 1000)
end

local aligns = {
  ["l"] = TEXT_ALIGN_LEFT,
  ["c"] = TEXT_ALIGN_CENTER,
  ["r"] = TEXT_ALIGN_RIGHT,
  ["t"] = TEXT_ALIGN_TOP,
  ["b"] = TEXT_ALIGN_BOTTOM
}

function CCR:DrawText(str, font, x, y, clr, ax, ay)
  draw.SimpleText(str, font, x, y, clr, aligns[ax or "l"], aligns[ay or "l"])
end

function CCR:DrawShadowText(px, str, font, x, y, clr, ax, ay)
  draw.SimpleText(str, font, x + px, y + px, ColorAlpha(color_black, clr.a), aligns[ax or "l"], aligns[ay or "l"])
  draw.SimpleText(str, font, x, y, clr, aligns[ax or "l"], aligns[ay or "l"])
end

function CCR:GetTextSize(text, font)
  surface.SetFont(font)
  local tw, th = surface.GetTextSize(text)
  return tw, th
end
