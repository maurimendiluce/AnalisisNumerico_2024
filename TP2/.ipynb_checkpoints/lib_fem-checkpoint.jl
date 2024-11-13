using DelaunayTriangulation, CairoMakie, LinearAlgebra, Plots, Polynomials

function rectangle_mesh(a,b,c,d,N;graficar=true)
    
    tri = triangulate_rectangle(a, b, c, d, N, N,delete_ghosts = true)

    if graficar == true
        display(triplot(tri))
    end
    return tri
end

function nodes_tri(tri)
    # función que devuelve la matriz de nodos de la triangulación

    points = get_points(tri)

    nodes = zeros(size(points)[1],2)
    for i=1:size(nodes)[1]
        nodes[i,1] = points[i][1]
        nodes[i,2] = points[i][2]
    end
    return nodes
end

function elements_tri(tri)
    #función que devuelve los triangulos numerados de la triangulación

    triangles = get_triangles(tri)
    elements = zeros(length(triangles),3)
    j=1
    for k in triangles
        elements[j,1],elements[j,2],elements[j,3] = k[1], k[2], k[3]
        j=j+1
    end
    
    elements = Int.(elements)

    return elements
end

function boundary_nodes(tri)
    #función que devuelve la numeración de los nodos de borde

    get_boundary = get_boundary_nodes(tri)
    boundary = [get_boundary[1];get_boundary[2];get_boundary[3];get_boundary[4]]    
    
    return unique(boundary)
end


function plot_u(u::Vector,tri;title = "titulo")
    #la función toma como argumento un vector u con las evaluaciones de la u en cada nodo y tri es el objeto que devuelve rectangle_mesh
    f, ax, tr  = tricontourf(tri, u,levels = 100,axis = (; aspect = 1, title))
    Colorbar(f[1, 2], tr)
    f
end

function plot_grad(∇u::Matrix,points)
    #la función toma como argumento una matriz con las evaluaciones del gradiente en cada nodo y tri es el objeto que devuelve rectangle_mesh
    display(Plots.quiver(points[:,1],points[:, 2],quiver=(∇u[:, 1]/norm(∇u[:, 1]),∇u[:, 2]/norm(∇u[:, 2]))))
end