# VPC, Subnet, RouteTable, IGW/NGW,

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_key}-${var.vpc_name}"
  }
}


#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_key}-${var.vpc_name}"
  }
}


# Route Tables
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_key}-${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_key}-${var.vpc_name}-private"
  }
}


# Subnets
# for_eachで複数のサブネットをまとめて生成している
resource "aws_subnet" "main" {
  for_each = var.vpc_subnet

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value["cidr"]

  tags = {
    Name = "${var.project_key}-${var.vpc_name}-${each.key}"
  }
}


# Route Table Association
# route_table_idのうまい指定方法が分からなかったのでConditional Expressionで無理やり場合分けしている
# 多分localにrouteブロックの情報を埋め込んでDynamic Blockを使ってRouteTableを定義するのが良い気がする
# サブネットがPublic Protected Private の3層構造になったら実装しよ
resource "aws_route_table_association" "a" {
  for_each = var.vpc_subnet

  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = each.value["route"] == "igw" ? aws_route_table.igw.id : aws_route_table.private.id
}