"use strict";

var dagre = require("dagre");
var lodash = require("lodash");
var psDagre = require("Dagre");

exports.layout = function(config) {
    return function(nodes) {
        return function(edges) {
            /**** Setup graph ******/
            var g = new dagre.graphlib.Graph();
            g.setGraph({});
            g.setDefaultEdgeLabel(function() { return {}; });

            nodes.map(function(nodeTuple) {
                var nodeId = nodeTuple.value0;
                var nodeLabel = lodash.cloneDeep(nodeTuple.value1);
                g.setNode(nodeId, nodeLabel);
            });

            edges.map(function(edgeTuple) {
                var edge = lodash.cloneDeep(labeledEdge.value0);
                var l = labeledEdge.value1;
                var edgeLabel = { minlen: l.minLength,
                                  weight: l.weight,
                                  width: l.width,
                                  height: l.height,
                                  labelpos: psDagre.showLabelPosition(l.labelPosition),
                                  labeloffset: l.labelOffset
                                };
                g.setEdge(edge.from, edge.to, edgeLabel);
            });


            /**** Run layout ********/
            dagre.layout(g, { rankdir: psDagre.showRankDirection(config.rankDirection),
                              align: psDagre.showAlign(config.align),
                              nodesep: config.nodeSep,
                              edgesep: config.edgeSep,
                              ranksep: config.rankSep,
                              marginx: config.marginX,
                              marginy: config.marginY,
                              acyclicer: psDagre.showAcyclicer(config.acyclicer),
                              ranker: psDagre.showRanker(config.ranker)
                            }
                        );


            /**** Get layout result into expected format ****/
            var nodesRes = g.nodes().map(function(nodeId) {
                var label = g.node(nodeId);
                var nodeResult =
                    { nodeId: nodeId,
                    position: { x: label.x,
                                y: label.y
                                }
                    };
                return nodeResult;
            });

            var edgesRes = g.edges().map(function(edge) {
                var label = g.edge(edge.v, edge.w);
                var edgeResult =
                    { edge: { from: edge.v,
                            to: edge.w
                            },
                    labelCenter: { x: label.x,
                                    y: label.y
                                },
                    controlPoints: label.points
                    };
                return edgeResult;
            });

            var result =
                { graphWidth: g.width,
                graphHeight: g.height,
                nodes: nodesRes,
                edges: edgesRes
                };


            return result;
        };
    };
};
