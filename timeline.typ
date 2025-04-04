#import "@preview/fletcher:0.5.7" as fletcher

// --- Configuration ---
#let timeline-abs-width = 25cm
#let start-year = 1940
#let end-year = 2030
#let y-offset = 1.5cm // Base vertical offset distance
#let marker-radius = 6pt
#let timeline_width = 3pt
#let conn_width = 1.5pt

// Colors
#let main-color = blue.darken(20%)
#let marker-color = orange.darken(10%)
#let anno-color-1 = teal.darken(30%)
#let anno-color-2 = purple.darken(20%)



// --- Helper function to calculate X position ---
#let get-x-pos(year, width) = {
  let factor = (year - start-year) / (end-year - start-year)
  factor * width
}

// --- Create the timeline ---
#let make_timeline(events) = align(center + horizon)[
  #set text(size: 14pt)

  // Use fletcher.diagram()
  #fletcher.diagram(
    {
    // --- Define invisible nodes for timeline ends ---
    fletcher.node(
      (0cm, 0cm),
      name: <tl-start>,
      fill: none, stroke: none
    )
    fletcher.node(
      (timeline-abs-width, 0cm),
      name: <tl-end>,
      fill: none, stroke: none
    )

    // --- Draw the main timeline axis ---
    fletcher.edge(
      <tl-start>, <tl-end>,
      "->",
      stroke: main-color + timeline_width,
    )

    // --- Add event markers and annotations ---
    for (i, event) in events.enumerate() {
      // Calculate positions and setup using the y_mult factor
      let x-pos = get-x-pos(event.year, timeline-abs-width)
      let marker-coord = (x-pos, 0cm)
      // Calculate offset based on multiplier
      let current-y-offset = event.y_mult * y-offset
      let anno-coord = (x-pos, current-y-offset)
      // Determine anchor based on positive/negative offset
      let anno-anchor = if event.y_mult > 0 { "south" } else { "north" }
      // Determine color based on positive/negative offset
      // let anno-color = if event.y_mult > 0 { anno-color-1 } else { anno-color-2 }
      let anno-color = anno-color-2
      let marker-name = label("marker-" + str(i))
      let anno-name = label("anno-" + str(i))

      // Define marker node
      fletcher.node(
        marker-coord,
        name: marker-name,
        fill: marker-color,
        shape: "circle",
        radius: marker-radius,
        stroke: none
      )

      // Define annotation node
      fletcher.node(
        anno-coord,
        name: anno-name,
        align(center)[
          #text(weight: "bold", anno-color)[#event.year] \
          #text(weight: "bold", event.title) \
          #emph(event.citation) // Keeping citation emphasized
        ]
      )

      // Connect marker to annotation
      fletcher.edge(
        marker-name,
        (name: anno-name, anchor: anno-anchor),
        stroke: (paint: anno-color, thickness: conn_width, dash: "dashed"),
      )
    }
  }) // End of diagram content
]


//
// Demo
//


// Autoscale output, without margins.
#set page(width: auto, height: auto, margin: 0%)

// Define some notable events.
#let events = (
  (year: 1948, title: [The 'Cognitive Map' concept], citation: "Tolman", y_mult: 1.0),
  (year: 1971, title: [Discovery of Place Cells in CA1], citation: "O'Keefe & Dostrovsky", y_mult: -1.0),
  (year: 1978, title: emph("The Hippocampus as a Cognitive Map"), citation: "O'Keefe & Nadel", y_mult: 2.0),
  (year: 2005, title: [Discovery of Grid Cells (GC) in MEC], citation: "Moser, Moser et al.", y_mult: -2.5),
  (year: 2016, title: "Maps for Abstract Knowledge", citation: "Various (e.g., Constantinescu)", y_mult: 1.2),
  (year: 2024, title: [#text(fill: red, [Maps for Mental Navigation]) (EC)], citation: "Neupane, Fiete, Jazayeri", y_mult: -1.0),
)
#make_timeline(events)
