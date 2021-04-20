--[[  Polyline implemented in lua.

MIT License

Copyright (c) 2017 Tanner Rogalsky

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local LINES_PARALLEL_EPS = 0.05;

local function Vector(x, y)
  if y then
    return {x = x, y = y}
  else -- clone vector
    return {x = x.x, y = x.y}
  end
end

local function length(vector)
  return math.sqrt(vector.x * vector.x + vector.y * vector.y)
end

local function normal(out, vector, scale)
  out.x = -vector.y * scale
  out.y = vector.x * scale
  return out
end

local function cross(x1, y1, x2, y2)
  return x1 * y2 - y1 * x2
end

local function renderEdgeNone(anchors, normals, s, len_s, ns, q, r, hw)
  table.insert(anchors, Vector(q))
  table.insert(anchors, Vector(q))
  table.insert(normals, Vector(ns))
  table.insert(normals, Vector(-ns.x, -ns.y))

  s.x, s.y = r.x - q.x, r.y - q.y
  len_s = length(s)
  normal(ns, s, hw / len_s)

  table.insert(anchors, Vector(q))
  table.insert(anchors, Vector(q))
  table.insert(normals, Vector(-ns.x, -ns.y))
  table.insert(normals, Vector(ns))

  return len_s
end

local function renderEdgeMiter(anchors, normals, s, len_s, ns, q, r, hw)
  local tx, ty = r.x - q.x, r.y - q.y
  local len_t = math.sqrt(tx * tx + ty * ty)
  local ntx, nty = -ty * (hw / len_t), tx * (hw / len_t)

  table.insert(anchors, Vector(q))
  table.insert(anchors, Vector(q))

  local det = cross(s.x, s.y, tx, ty)
  if (math.abs(det) / (len_s * len_t) < LINES_PARALLEL_EPS) and (s.x * tx + s.y * ty > 0) then
    -- lines parallel, compute as u1 = q + ns * w/2, u2 = q - ns * w/2
    table.insert(normals, Vector(ns))
    table.insert(normals, Vector(-ns.x, -ns.y))
  else
    -- cramers rule
    local nx, ny = ntx - ns.x, nty - ns.y
    local lambda = cross(nx, ny, tx, ty) / det
    local dx, dy = ns.x + (s.x * lambda), ns.y + (s.y * lambda)

    table.insert(normals, Vector(dx, dy))
    table.insert(normals, Vector(-dx, -dy))
  end

  s.x, s.y = tx, ty
  ns.x, ns.y = ntx, nty
  return len_t
end

local function renderEdgeBevel(anchors, normals, s, len_s, ns, q, r, hw)
  local tx, ty = r.x - q.x, r.y - q.y
  local len_t = math.sqrt(tx * tx + ty * ty)
  local ntx, nty = -ty * (hw / len_t), tx * (hw / len_t)

  local det = cross(s.x, s.y, tx, ty)
  if (math.abs(det) / (len_s * len_t) < LINES_PARALLEL_EPS) and (s.x * tx + s.y * ty > 0) then
    -- lines parallel, compute as u1 = q + ns * w/2, u2 = q - ns * w/2
    table.insert(anchors, Vector(q))
    table.insert(anchors, Vector(q))
    table.insert(normals, Vector(ntx, nty))
    table.insert(normals, Vector(-ntx, -nty))

    s.x, s.y = tx, ty
    return len_t -- early out
  end

  -- cramers rule
  local nx, ny = ntx - ns.x, nty - ns.y
  local lambda = cross(nx, ny, tx, ty) / det
  local dx, dy = ns.x + (s.x * lambda), ns.y + (s.y * lambda)

  table.insert(anchors, Vector(q))
  table.insert(anchors, Vector(q))
  table.insert(anchors, Vector(q))
  table.insert(anchors, Vector(q))
  if det > 0 then -- 'left' turn
    table.insert(normals, Vector(dx, dy))
    table.insert(normals, Vector(-ns.x, -ns.y))
    table.insert(normals, Vector(dx, dy))
    table.insert(normals, Vector(-ntx, -nty))
  else
    table.insert(normals, Vector(ns.x, ns.y))
    table.insert(normals, Vector(-dx, -dy))
    table.insert(normals, Vector(ntx, nty))
    table.insert(normals, Vector(-dx, -dy))
  end

  s.x, s.y = tx, ty
  ns.x, ns.y = ntx, nty
  return len_t
end

local function renderOverdraw(vertices, offset, vertex_count, overdraw_vertex_count, normals, pixel_size, is_looping)
  for i=1,vertex_count,2 do
    vertices[i + offset] = {vertices[i][1], vertices[i][2]}
    local length = length(normals[i])
    vertices[i + offset + 1] = {
      vertices[i][1] + normals[i].x * (pixel_size / length),
      vertices[i][2] + normals[i].y * (pixel_size / length)
    }
  end

  for i=1,vertex_count,2 do
    local k = vertex_count - i + 1
    vertices[offset + vertex_count + i] = {vertices[k][1], vertices[k][2]}
    local length = length(normals[i])
    vertices[offset + vertex_count + i + 1] = {
      vertices[k][1] + normals[k].x * (pixel_size / length),
      vertices[k][2] + normals[k].y * (pixel_size / length)
    }
  end

  if not is_looping then
    local spacerx, spacery = vertices[offset + 1][1] - vertices[offset + 3][1], vertices[offset + 1][2] - vertices[offset + 3][2]
    local spacer_length = math.sqrt(spacerx * spacerx + spacery * spacery)
    spacerx, spacery = spacerx * (pixel_size / spacer_length), spacery * (pixel_size / spacer_length)
    vertices[offset + 2][1], vertices[offset + 2][2] = vertices[offset + 2][1] + spacerx, vertices[offset + 2][2] + spacery
    vertices[offset + overdraw_vertex_count - 2][1] = vertices[offset + overdraw_vertex_count - 2][1] + spacerx
    vertices[offset + overdraw_vertex_count - 2][2] = vertices[offset + overdraw_vertex_count - 2][2] + spacery

    spacerx = vertices[offset + vertex_count - 0][1] - vertices[offset + vertex_count - 2][1]
    spacery = vertices[offset + vertex_count - 0][2] - vertices[offset + vertex_count - 2][2]
    spacer_length = math.sqrt(spacerx * spacerx + spacery * spacery)
    spacerx, spacery = spacerx * (pixel_size / spacer_length), spacery * (pixel_size / spacer_length)
    vertices[offset + vertex_count][1] = vertices[offset + vertex_count][1] + spacerx
    vertices[offset + vertex_count][2] = vertices[offset + vertex_count][2] + spacery
    vertices[offset + vertex_count + 2][1] = vertices[offset + vertex_count + 2][1] + spacerx
    vertices[offset + vertex_count + 2][2] = vertices[offset + vertex_count + 2][2] + spacery

    vertices[offset + overdraw_vertex_count - 1] = vertices[offset + 1]
    vertices[offset + overdraw_vertex_count - 0] = vertices[offset + 2]
  end
end

local function renderOverdrawNone(vertices, offset, vertex_count, overdraw_vertex_count, normals, pixel_size, is_looping)
  for i=1,vertex_count-1,4 do
    local sx, sy = vertices[i][1] - vertices[i + 3][1], vertices[i][2] - vertices[i + 3][2]
    local tx, ty = vertices[i][1] - vertices[i + 1][1], vertices[i][2] - vertices[i + 1][2]
    local sl = math.sqrt(sx * sx + sy * sy)
    local tl = math.sqrt(tx * tx + ty * ty)
    sx, sy = sx * (pixel_size / sl), sy * (pixel_size / sl)
    tx, ty = tx * (pixel_size / tl), ty * (pixel_size / tl)

    local k = 4 * (i - 1) + 1 + offset
    vertices[k + 00] = {vertices[i + 0][1], vertices[i + 0][2]}
    vertices[k + 01] = {vertices[i + 0][1] + sx + tx, vertices[i + 0][2] + sy + ty}
    vertices[k + 02] = {vertices[i + 1][1] + sx - tx, vertices[i + 1][2] + sy - ty}
    vertices[k + 03] = {vertices[i + 1][1], vertices[i + 1][2]}

    vertices[k + 04] = {vertices[i + 1][1], vertices[i + 1][2]}
    vertices[k + 05] = {vertices[i + 1][1] + sx - tx, vertices[i + 1][2] + sy - ty}
    vertices[k + 06] = {vertices[i + 2][1] - sx - tx, vertices[i + 2][2] - sy - ty}
    vertices[k + 07] = {vertices[i + 2][1], vertices[i + 2][2]}

    vertices[k + 08] = {vertices[i + 2][1], vertices[i + 2][2]}
    vertices[k + 09] = {vertices[i + 2][1] - sx - tx, vertices[i + 2][2] - sy - ty}
    vertices[k + 10] = {vertices[i + 3][1] - sx + tx, vertices[i + 3][2] - sy + ty}
    vertices[k + 11] = {vertices[i + 3][1], vertices[i + 3][2]}

    vertices[k + 12] = {vertices[i + 3][1], vertices[i + 3][2]}
    vertices[k + 13] = {vertices[i + 3][1] - sx + tx, vertices[i + 3][2] - sy + ty}
    vertices[k + 14] = {vertices[i + 0][1] + sx + tx, vertices[i + 0][2] + sy + ty}
    vertices[k + 15] = {vertices[i + 0][1], vertices[i + 0][2]}
  end
end

local JOIN_TYPES = {
  miter = renderEdgeMiter,
  none = renderEdgeNone,
  bevel = renderEdgeBevel,
}

function polyline(join_type, coords, half_width, pixel_size, draw_overdraw)
  local renderEdge = JOIN_TYPES[join_type]
  assert(renderEdge, join_type .. ' is not a valid line join type.')

  local anchors = {}
  local normals = {}

  if draw_overdraw then
    half_width = half_width - pixel_size * 0.3
  end

  local is_looping = (coords[1] == coords[#coords - 1]) and (coords[2] == coords[#coords])
  local s
  if is_looping then
    s = Vector(coords[1] - coords[#coords - 3], coords[2] - coords[#coords - 2])
  else
    s = Vector(coords[3] - coords[1], coords[4] - coords[2])
  end

  local len_s = length(s)
  local ns = normal({}, s, half_width / len_s)

  local r, q = Vector(coords[1], coords[2]), Vector(0, 0)
  for i=1,#coords-2,2 do
    q.x, q.y = r.x, r.y
    r.x, r.y = coords[i + 2], coords[i + 3]
    len_s = renderEdge(anchors, normals, s, len_s, ns, q, r, half_width)
  end

  q.x, q.y = r.x, r.y
  if is_looping then
    r.x, r.y = coords[3], coords[4]
  else
    r.x, r.y = r.x + s.x, r.y + s.y
  end
  len_s = renderEdge(anchors, normals, s, len_s, ns, q, r, half_width)

  local vertices = {}
  local indices = nil
  local draw_mode = 'strip'
  local vertex_count = #normals

  local extra_vertices = 0
  local overdraw_vertex_count = 0
  if draw_overdraw then
    if join_type == 'none' then
      overdraw_vertex_count = 4 * (vertex_count - 4 - 1)
    else
      overdraw_vertex_count = 2 * vertex_count
      if not is_looping then overdraw_vertex_count = overdraw_vertex_count + 2 end
      extra_vertices = 2
    end
  end

  if join_type == 'none' then
    vertex_count = vertex_count - 4
    for i=3,#normals-2 do
      table.insert(vertices, {
        anchors[i].x + normals[i].x,
        anchors[i].y + normals[i].y,
        0, 0, 255, 255, 255, 255
      })
    end
    draw_mode = 'triangles'
  else
    for i=1,vertex_count do
      table.insert(vertices, {
        anchors[i].x + normals[i].x,
        anchors[i].y + normals[i].y,
        0, 0, 255, 255, 255, 255
      })
    end
  end

  if draw_overdraw then
    if join_type == 'none' then
      renderOverdrawNone(vertices, vertex_count + extra_vertices, vertex_count, overdraw_vertex_count, normals, pixel_size, is_looping)
      for i=vertex_count+1+extra_vertices,#vertices do
        if ((i % 4) < 2) then
          vertices[i][8] = 255
        else
          vertices[i][8] = 0
        end
      end
    else
      renderOverdraw(vertices, vertex_count + extra_vertices, vertex_count, overdraw_vertex_count, normals, pixel_size, is_looping)
      for i=vertex_count+1+extra_vertices,#vertices do
        vertices[i][8] = 255 * (i % 2) -- alpha
      end
    end
  end

  if extra_vertices > 0 then
    vertices[vertex_count + 1] = {vertices[vertex_count][1], vertices[vertex_count][2]}
    vertices[vertex_count + 2] = {vertices[vertex_count + 3][1], vertices[vertex_count + 3][2]}
  end

  if draw_mode == 'triangles' then
    indices = {}
    local num_indices = (vertex_count + extra_vertices + overdraw_vertex_count) / 4
    for i=0,num_indices-1 do
      -- First triangle.
      table.insert(indices, i * 4 + 0 + 1)
      table.insert(indices, i * 4 + 1 + 1)
      table.insert(indices, i * 4 + 2 + 1)

      -- Second triangle.
      table.insert(indices, i * 4 + 0 + 1)
      table.insert(indices, i * 4 + 2 + 1)
      table.insert(indices, i * 4 + 3 + 1)
    end
  end

  return vertices, indices, draw_mode
end
