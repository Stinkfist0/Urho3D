class EditAction
{
    void Undo()
    {
    }
    
    void Redo()
    {
    }
}

class EditActionGroup
{
    Array<EditAction@> actions;
}

class CreateNodeAction : EditAction
{
    uint nodeID;
    uint parentID;
    XMLFile@ nodeData;

    void Define(Node@ node)
    {
        nodeID = node.id;
        parentID = node.parent.id;
        nodeData = XMLFile();
        XMLElement rootElem = nodeData.CreateRoot("node");
        node.SaveXML(rootElem);
    }

    void Undo()
    {
        Node@ parent = editorScene.GetNode(parentID);
        Node@ node = editorScene.GetNode(nodeID);
        if (parent !is null && node !is null)
        {
            ClearSceneSelection();
            parent.RemoveChild(node);
        }
    }
    
    void Redo()
    {
        Node@ parent = editorScene.GetNode(parentID);
        if (parent !is null)
        {
            Node@ node = parent.CreateChild("", nodeID < FIRST_LOCAL_ID ? REPLICATED : LOCAL, nodeID);
            node.LoadXML(nodeData.root);
        }
    }
}

class DeleteNodeAction : EditAction
{
    uint nodeID;
    uint parentID;
    XMLFile@ nodeData;

    void Define(Node@ node)
    {
        nodeID = node.id;
        parentID = node.parent.id;
        nodeData = XMLFile();
        XMLElement rootElem = nodeData.CreateRoot("node");
        node.SaveXML(rootElem);
    }

    void Undo()
    {
        Node@ parent = editorScene.GetNode(parentID);
        if (parent !is null)
        {
            Node@ node = parent.CreateChild("", nodeID < FIRST_LOCAL_ID ? REPLICATED : LOCAL, nodeID);
            node.LoadXML(nodeData.root);
        }
    }
    
    void Redo()
    {
        Node@ parent = editorScene.GetNode(parentID);
        Node@ node = editorScene.GetNode(nodeID);
        if (parent !is null && node !is null)
        {
            ClearSceneSelection();
            parent.RemoveChild(node);
        }
    }
}

class ReparentNodeAction : EditAction
{
    uint nodeID;
    uint oldParentID;
    uint newParentID;
    
    void Define(Node@ node, Node@ newParent)
    {
        nodeID = node.id;
        oldParentID = node.parent.id;
        newParentID = newParent.id;
    }

    void Undo()
    {
        Node@ parent = editorScene.GetNode(oldParentID);
        Node@ node = editorScene.GetNode(nodeID);
        if (parent !is null && node !is null)
            node.parent = parent;
    }

    void Redo()
    {
        Node@ parent = editorScene.GetNode(newParentID);
        Node@ node = editorScene.GetNode(nodeID);
        if (parent !is null && node !is null)
            node.parent = parent;
    }
}