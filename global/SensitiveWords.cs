using Godot;
using System;
using ToolGood.Words;

public partial class SensitiveWords : Node
{

    StringSearchEx iwords = new StringSearchEx();

    public override void _Ready()
    {
        String str = FileAccess.GetFileAsString("res://client/sensitive_words.txt");
        iwords.SetKeywords(str.Split('、'));
    }
    public bool IsSensitive(String text)
    {
        return iwords.ContainsAny(text);
    }
}
