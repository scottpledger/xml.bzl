"XML builder functions for constructing XML documents programmatically"

load(":parser.bzl", "NODE_CDATA", "NODE_COMMENT", "NODE_DOCUMENT", "NODE_ELEMENT", "NODE_PROCESSING_INSTRUCTION", "NODE_TEXT")

def element(tag_name, attributes = None, children = None):
    """Create an element node.

    Example:
        ```
        div = xml.element("div", {"class": "container"}, [
            xml.element("p", children = [xml.text("Hello, world!")]),
        ])
        print(xml.to_string(div))
        # <div class="container">
        #   <p>Hello, world!</p>
        # </div>
        ```

    Args:
        tag_name: The tag name for the element.
        attributes: Optional dict of attribute names to values.
        children: Optional list of child nodes (elements, text, etc.).

    Returns:
        An element node that can be serialized with xml.to_string().
    """
    return struct(
        node_type = NODE_ELEMENT,
        tag_name = tag_name,
        attributes = attributes if attributes else {},
        children = children if children else [],
        parent = None,
    )

def text(content):
    """Create a text node.

    Example:
        ```
        p = xml.element("p", children = [xml.text("Hello <world>")])
        print(xml.to_string(p))
        # <p>Hello &lt;world&gt;</p>
        ```

    Args:
        content: The text content. Special characters will be escaped
            when serialized.

    Returns:
        A text node that can be used as a child of an element.
    """
    return struct(
        node_type = NODE_TEXT,
        content = content,
        parent = None,
    )

def comment(content):
    """Create a comment node.

    Example:
        ```
        node = xml.comment("This is a comment")
        print(xml.to_string(node))
        # <!--This is a comment-->
        ```

    Args:
        content: The comment content.

    Returns:
        A comment node.
    """
    return struct(
        node_type = NODE_COMMENT,
        content = content,
        parent = None,
    )

def cdata(content):
    """Create a CDATA section node.

    Example:
        ```
        node = xml.cdata("<script>alert('hi')</script>")
        print(xml.to_string(node))
        # <![CDATA[<script>alert('hi')</script>]]>
        ```

    Args:
        content: The CDATA content (not escaped).

    Returns:
        A CDATA node.
    """
    return struct(
        node_type = NODE_CDATA,
        content = content,
        parent = None,
    )

def processing_instruction(target, content = ""):
    """Create a processing instruction node.

    Example:
        ```
        pi = xml.processing_instruction("xml-stylesheet", 'type="text/xsl" href="style.xsl"')
        print(xml.to_string(pi))
        # <?xml-stylesheet type="text/xsl" href="style.xsl"?>
        ```

    Args:
        target: The PI target (e.g., "xml-stylesheet").
        content: The PI content/data.

    Returns:
        A processing instruction node.
    """
    return struct(
        node_type = NODE_PROCESSING_INSTRUCTION,
        target = target,
        content = content,
        parent = None,
    )

def document(children = None, xml_declaration = None):
    """Create a document node.

    Example:
        ```
        doc = xml.document(
            xml_declaration = 'version="1.0" encoding="utf-8"',
            children = [
                xml.element("root", children = [
                    xml.element("child", children = [xml.text("content")]),
                ]),
            ],
        )
        print(xml.to_string(doc))
        # <?xml version="1.0" encoding="utf-8"?>
        # <root>
        #   <child>content</child>
        # </root>
        ```

    Args:
        children: List of child nodes (typically one root element).
        xml_declaration: Optional XML declaration string (e.g., 'version="1.0" encoding="utf-8"').

    Returns:
        A document node that can be serialized with xml.to_string().
    """
    return struct(
        node_type = NODE_DOCUMENT,
        children = children if children else [],
        xml_declaration = xml_declaration,
        doctype = None,
        errors = [],
    )
