"use strict";

var dagre = require("dagre");
var lodash = require("lodash");

exports.layout = function(nodes) {
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
            var edgeLabel = lodash.cloneDeep(labeledEdge.value1);
            g.setEdge(edge.from, edge.to, edgeLabel);
        });


        /**** Run layout ********/
        dagre.layout(g);


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
