Return-Path: <linux-fscrypt+bounces-351-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0BF92CDDA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 11:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E770B21891
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 09:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC1C818EFF9;
	Wed, 10 Jul 2024 09:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aUyLyxpp"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD14C17C205
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 09:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720602283; cv=none; b=pTK2gsOy3gblPNHqtnjee/N2B0VdTfCfqzyFyfyYQHWRdilyYcN7h3bA9BQwBVlL4efTj6pnrEwKPinuu7kUrRU++DnbjbNzJAZ8KJThh23/psj3ZlOgoe8076DOsg+Ddao70WcWAgfbcrYH7gPlso9f3I7LAg61pITVdXYbht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720602283; c=relaxed/simple;
	bh=oUu8gDOXAHlSWSRic8g1f5D0GBlmPt1NCAuCNH56ROI=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=CZF0cukgRI/8qpc0klZXyx9Csa13AWNvIZJqm7G5rA2jieoqymdkkcz6fa5s3zTUMjNDmNWFA8sCgwoetiFi2bHv9wBsRXSLgoqF+FBEQDvj+k1vmRLbmm7LJikUxVreHTXBqQ2GFEKBepQaIgToC6VidlOKxE/l6VwyQ6iJoMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aUyLyxpp; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240710090433epoutp04689e923e0911e1f9c3bb15ff44eb8bdf~gzqbE3yXU2760827608epoutp04W
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 09:04:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240710090433epoutp04689e923e0911e1f9c3bb15ff44eb8bdf~gzqbE3yXU2760827608epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720602273;
	bh=oUu8gDOXAHlSWSRic8g1f5D0GBlmPt1NCAuCNH56ROI=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=aUyLyxppa2g5z+eXTSpRV891JvDmFKaSYJWSdS9UlaJ0K9NEWCOYRg0w564XoZOHO
	 pxLH9fJoM2q0ba/jpPcv8YO4YZAwja/xwcVtz9itCwATkqGnZmGbMFOKNt1EKRqkXB
	 bFzoYbeGrX6VgQWAyHYiVtUHoHir9nLDtMJna4Sk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240710090432epcas5p3f891edd026d4c99161908f32086a0a41~gzqapRDdp0626606266epcas5p3Z;
	Wed, 10 Jul 2024 09:04:32 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WJsPB6g52z4x9Pt; Wed, 10 Jul
	2024 09:04:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	13.AF.06857.E9E4E866; Wed, 10 Jul 2024 18:04:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240710090430epcas5p35bfe6fcde7ba781ea438b359de718aba~gzqYfVFsW0036700367epcas5p3o;
	Wed, 10 Jul 2024 09:04:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240710090430epsmtrp276b1a547516f94b83995be3cef670913~gzqYegmmf0987709877epsmtrp2Y;
	Wed, 10 Jul 2024 09:04:30 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-15-668e4e9e292d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A3.57.29940.E9E4E866; Wed, 10 Jul 2024 18:04:30 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710090427epsmtip13e8bd8ef6b80e9dc908599b64e726cce~gzqVoFavz0286002860epsmtip1Q;
	Wed, 10 Jul 2024 09:04:27 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-samsung-soc@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	"'Avri Altman'" <avri.altman@wdc.com>, "'Bart	Van Assche'"
	<bvanassche@acm.org>, "'Martin K . Petersen'" <martin.petersen@oracle.com>,
	"'Peter Griffin'" <peter.griffin@linaro.org>,
	=?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'William
 McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708235330.103590-7-ebiggers@kernel.org>
Subject: RE: [PATCH v3 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Date: Wed, 10 Jul 2024 14:34:24 +0530
Message-ID: <019401dad2a8$2c3488b0$849d9a10$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHC4eaVKc/l097EGvITZfSx67wqzAKmrw7ZAXLRjb+x/r5QEA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmpu48v740g+8fDS22vNrMYvHy51U2
	i2kffjJbrN3zh9ni1bxvLBYzzu9jsui+voPNYvnxf0wWG2b8Y7FY9ek/owOXx+Ur3h4LNpV6
	bFrVyeZx59oeNo+PT2+xeHzeJOfRfqCbKYA9KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpB
	Sk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xvqLc5kK5i9hrNgzcwFbA+Ol+YxdjJwcEgIm
	Eg/bFjF1MXJxCAnsZpTYce4XO4TziVHi2dUZbBDON0aJTT8/wbXsbP7CDJHYyyjRObkfquoF
	o8SHjwvYQKrYBHQldixuA7NFBDwkzvdfZAexmQW+MEm8e6EOYnMKWEmsmz2ZGcQWFoiVuHfx
	KVg9i4CqxJyfb8C28QpYSpy6Ow3KFpQ4OfMJC8QcbYllC18zQ1ykIPHz6TJWiF1OEm3f7rJB
	1IhLvDx6BOwfCYEtHBLHn2yGanCReNv2nB3CFpZ4dXwLlC0l8fndXjYIO1vi+MVZUHaFRHfr
	R6gae4mdj24CHcEBtEBTYv0ufYhdfBK9v58wgYQlBHglOtqEIKpVJZrfXWWBsKUlJnZ3s0LY
	HhKfvp1gn8CoOAvJZ7OQfDYLyQezEJYtYGRZxSiZWlCcm55abFpgnJdaDo/y5PzcTYzg5Kvl
	vYPx0YMPeocYmTgYDzFKcDArifDOv9GdJsSbklhZlVqUH19UmpNafIjRFBjcE5mlRJPzgek/
	ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGprr05pvCLR8TFacd
	mn3+UvFTS/8JNy/aPO5WjbrFyrgq6/0aB5WunTImun8OPr27bgYPJ2Nx4+PwxDkusXHPlA/H
	LynesSj9x72Xz4xkLMzr+cPT016WuM+Nz7p8+exCv6u9x7Um+530qj1UJ35TY0fbT6F2XSNr
	JbbTTAZ58bPSz0+sOThxcsysCZdyunOlFzEfu3/W4cF9CYOrExbwCP59nOufZG10/J/Fz4hH
	X6sOs8zR9dh1LcNb+Fs+5xHh1UlJ2tcjAqa5/V1wVdf7tVjDb+1uSQ+ubhEDa7PEko9aubp3
	l6t6WNl6p/DuPtP5f3lPTnfxGafIE20zZcRnWiq+PF2TPOWekunqKUeUlFiKMxINtZiLihMB
	j5mpYEcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSnO48v740g+93hCy2vNrMYvHy51U2
	i2kffjJbrN3zh9ni1bxvLBYzzu9jsui+voPNYvnxf0wWG2b8Y7FY9ek/owOXx+Ur3h4LNpV6
	bFrVyeZx59oeNo+PT2+xeHzeJOfRfqCbKYA9issmJTUnsyy1SN8ugStj394dbAWt+RVXZi1i
	bmCcGdHFyMkhIWAisbP5C3MXIxeHkMBuRokPfy6zQySkJa5vnABlC0us/PecHaLoGaPE1Gff
	WUASbAK6EjsWt7GB2CICXhJdrZNYQIqYBX4wSfxdeZQRomMno8TcBWfAqjgFrCTWzZ7MDGIL
	C0RLfPv2DsxmEVCVmPPzDSOIzStgKXHq7jQoW1Di5MwnYNuYBbQlnt58CmcvW/iaGeI8BYmf
	T5exQlzhJNH27S4bRI24xMujR9gnMArPQjJqFpJRs5CMmoWkZQEjyypGydSC4tz03GLDAsO8
	1HK94sTc4tK8dL3k/NxNjOAI1NLcwbh91Qe9Q4xMHIyHGCU4mJVEeOff6E4T4k1JrKxKLcqP
	LyrNSS0+xCjNwaIkziv+ojdFSCA9sSQ1OzW1ILUIJsvEwSnVwMR6NKY5fU0nT97EXumr0dJn
	DGJUZCOuX+VaG2GdzFCzYp+33pxNX0S917UU/HuyNbt0du5LBsODlfyLFY49d9x+KMKp7tfP
	kIq6/KYDC+7sKE0VDL2Yffkj+5nely/Ev8nMM5xSX+30wvdC7CN/N/NVa202lgtFX7vj/lF5
	ntLhpp27EqLyZ3cumcV0OSn4c0wn42px80Pn7gmcuVFZrGmqlsTx7634BNlWpQ86BxK2/P7Q
	WflyyVKD5RGSiX80ltbUWfZMNHX/+SMoX2SL4RYjS7Oih88MfeNWXZm552HS86o8P7e5TK7b
	s7LNN7zrFjK2VthrzGT18UTcSpmMlYJLY3apXvrzRmqK+qWFzEosxRmJhlrMRcWJAIdZsEEv
	AwAA
X-CMS-MailID: 20240710090430epcas5p35bfe6fcde7ba781ea438b359de718aba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708235541epcas5p3ab7024f090bea9314d76c48762da6e09
References: <20240708235330.103590-1-ebiggers@kernel.org>
	<CGME20240708235541epcas5p3ab7024f090bea9314d76c48762da6e09@epcas5p3.samsung.com>
	<20240708235330.103590-7-ebiggers@kernel.org>



> -----Original Message-----
> From: Eric Biggers <ebiggers=40kernel.org>
> Sent: Tuesday, July 9, 2024 5:24 AM
> To: linux-scsi=40vger.kernel.org
> Cc: linux-samsung-soc=40vger.kernel.org; linux-fscrypt=40vger.kernel.org;=
 Alim
> Akhtar <alim.akhtar=40samsung.com>; Avri Altman <avri.altman=40wdc.com>;
> Bart Van Assche <bvanassche=40acm.org>; Martin K . Petersen
> <martin.petersen=40oracle.com>; Peter Griffin <peter.griffin=40linaro.org=
>;
> Andr=C3=A9=20Draszik=20<andre.draszik=40linaro.org>;=20William=20McVicker=
=0D=0A>=20<willmcvicker=40google.com>=0D=0A>=20Subject:=20=5BPATCH=20v3=206=
/6=5D=20scsi:=20ufs:=20exynos:=20Add=20support=20for=20Flash=20Memory=0D=0A=
>=20Protector=20(FMP)=0D=0A>=20=0D=0A>=20From:=20Eric=20Biggers=20<ebiggers=
=40google.com>=0D=0A>=20=0D=0A>=20Add=20support=20for=20Flash=20Memory=20Pr=
otector=20(FMP),=20which=20is=20the=20inline=0D=0A>=20encryption=20hardware=
=20on=20Exynos=20and=20Exynos-based=20SoCs.=0D=0A>=20=0D=0A>=20Specifically=
,=20add=20support=20for=20the=20=22traditional=20FMP=20mode=22=20that=20wor=
ks=20on=20many=0D=0A>=20Exynos-based=20SoCs=20including=20gs101.=20=20This=
=20is=20the=20mode=20that=20uses=20=22software=0D=0A>=20keys=22=20and=20is=
=20compatible=20with=20the=20upstream=20kernel's=20existing=20inline=20encr=
yption=0D=0A>=20framework=20in=20the=20block=20and=20filesystem=20layers.=
=20=20I=20plan=20to=20add=20support=20for=20the=0D=0A>=20wrapped=20key=20su=
pport=20on=20gs101=20at=20a=20later=20time.=0D=0A>=20=0D=0A>=20Tested=20on=
=20gs101=20(specifically=20Pixel=206)=20by=20running=20the=20'encrypt'=20gr=
oup=20of=0D=0A>=20xfstests=20on=20a=20filesystem=20mounted=20with=20the=20'=
inlinecrypt'=20mount=20option.=0D=0A>=20=0D=0A>=20Signed-off-by:=20Eric=20B=
iggers=20<ebiggers=40google.com>=0D=0A>=20---=0D=0A>=20=20drivers/ufs/host/=
ufs-exynos.c=20=7C=20240=0D=0A>=20+++++++++++++++++++++++++++++++++-=0D=0A>=
=20=201=20file=20changed,=20234=20insertions(+),=206=20deletions(-)=0D=0A>=
=20=0D=0A>=20diff=20--git=20a/drivers/ufs/host/ufs-exynos.c=20b/drivers/ufs=
/host/ufs-exynos.c=0D=0A>=20index=2088d125d1ee3c..16ad3528d80b=20100644=0D=
=0A>=20---=20a/drivers/ufs/host/ufs-exynos.c=0D=0A>=20+++=20b/drivers/ufs/h=
ost/ufs-exynos.c=0D=0A>=20=40=40=20-6,10=20+6,13=20=40=40=0D=0A>=20=20=20*=
=20Author:=20Seungwon=20Jeon=20=20<essuuj=40gmail.com>=0D=0A>=20=20=20*=20A=
uthor:=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>=0D=0A>=20=20=20*=0D=0A=
>=20=20=20*/=0D=0A>=20=0D=0A>=20+=23include=20<asm/unaligned.h>=0D=0A>=20+=
=23include=20<crypto/aes.h>=0D=0A>=20+=23include=20<linux/arm-smccc.h>=0D=
=0A>=20=20=23include=20<linux/clk.h>=0D=0A>=20=20=23include=20<linux/delay.=
h>=0D=0A>=20=20=23include=20<linux/module.h>=0D=0A>=20=20=23include=20<linu=
x/of.h>=0D=0A>=20=20=23include=20<linux/of_address.h>=0D=0A>=20=40=40=20-23=
,16=20+26,17=20=40=40=0D=0A>=20=20=23include=20<ufs/ufshci.h>=0D=0A>=20=20=
=23include=20<ufs/unipro.h>=0D=0A>=20=0D=0A>=20=20=23include=20=22ufs-exyno=
s.h=22=0D=0A>=20=0D=0A>=20+=23define=20DATA_UNIT_SIZE=09=094096=0D=0A>=20+=
=0D=0A>=20=20/*=0D=0A>=20=20=20*=20Exynos's=20Vendor=20specific=20registers=
=20for=20UFSHCI=0D=0A>=20=20=20*/=0D=0A>=20=20=23define=20HCI_TXPRDT_ENTRY_=
SIZE=090x00=0D=0A>=20=20=23define=20PRDT_PREFECT_EN=09=09BIT(31)=0D=0A>=20-=
=23define=20PRDT_SET_SIZE(x)=09((x)=20&=200x1F)=0D=0A>=20=20=23define=20HCI=
_RXPRDT_ENTRY_SIZE=090x04=0D=0A>=20=20=23define=20HCI_1US_TO_CNT_VAL=090x0C=
=0D=0A>=20=20=23define=20CNT_VAL_1US_MASK=090x3FF=0D=0A>=20=20=23define=20H=
CI_UTRL_NEXUS_TYPE=090x40=0D=0A>=20=20=23define=20HCI_UTMRL_NEXUS_TYPE=090x=
44=0D=0A>=20=40=40=20-1041,12=20+1045,12=20=40=40=20static=20int=20exynos_u=
fs_post_link(struct=20ufs_hba=0D=0A>=20*hba)=0D=0A>=20=0D=0A>=20=20=09exyno=
s_ufs_establish_connt(ufs);=0D=0A>=20=20=09exynos_ufs_fit_aggr_timeout(ufs)=
;=0D=0A>=20=0D=0A>=20=20=09hci_writel(ufs,=200xa,=20HCI_DATA_REORDER);=0D=
=0A>=20-=09hci_writel(ufs,=20PRDT_SET_SIZE(12),=20HCI_TXPRDT_ENTRY_SIZE);=
=0D=0A>=20-=09hci_writel(ufs,=20PRDT_SET_SIZE(12),=20HCI_RXPRDT_ENTRY_SIZE)=
;=0D=0A>=20+=09hci_writel(ufs,=20ilog2(DATA_UNIT_SIZE),=20HCI_TXPRDT_ENTRY_=
SIZE);=0D=0A>=20+=09hci_writel(ufs,=20ilog2(DATA_UNIT_SIZE),=20HCI_RXPRDT_E=
NTRY_SIZE);=0D=0A=0D=0AThese=20changes=20can=20be=20added=20(as=20separate=
=20patch)=20irrespective=20of=20FMP=20support.=20=0D=0AWill=20leave=20upto=
=20you=20though.=20=0D=0A=0D=0ALGTM,=0D=0A=0D=0AReviewed-by:=20Alim=20Akhta=
r=20<alim.akhtar=40samsung.com>=0D=0A=0D=0A>=20=20=09hci_writel(ufs,=20(1=
=20<<=20hba->nutrs)=20-=201,=20HCI_UTRL_NEXUS_TYPE);=0D=0A>=20=20=09hci_wri=
tel(ufs,=20(1=20<<=20hba->nutmrs)=20-=201,=20HCI_UTMRL_NEXUS_TYPE);=0D=0A>=
=20=20=09hci_writel(ufs,=200xf,=20HCI_AXIDMA_RWDATA_BURST_LEN);=0D=0A>=20=
=0D=0A>=20=20=09if=20(ufs->opts=20&=20EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)=
=0D=0A>=20=40=40=20-1149,10=20+1153,231=20=40=40=20static=20inline=20void=
=20exynos_ufs_priv_init(struct=0D=0A>=20ufs_hba=20*hba,=0D=0A>=20=20=09=09u=
fs->rx_sel_idx=20=3D=200;=0D=0A>=20=20=09hba->priv=20=3D=20(void=20*)ufs;=
=0D=0A>=20=20=09hba->quirks=20=3D=20ufs->drv_data->quirks;=0D=0A>=20=20=7D=
=0D=0A>=20=0D=0A>=20+=23ifdef=20CONFIG_SCSI_UFS_CRYPTO=0D=0A>=20+=0D=0A>=20=
+/*=0D=0A>=20+=20*=20Support=20for=20Flash=20Memory=20Protector=20(FMP),=20=
which=20is=20the=20inline=0D=0A>=20+encryption=0D=0A>=20+=20*=20hardware=20=
on=20Exynos=20and=20Exynos-based=20SoCs.=20=20The=20interface=20to=20this=
=0D=0A>=20+hardware=20is=0D=0A>=20+=20*=20not=20compatible=20with=20the=20s=
tandard=20UFS=20crypto.=20=20It=20requires=20that=0D=0A>=20+encryption=20be=
=0D=0A>=20+=20*=20configured=20in=20the=20PRDT=20using=20a=20nonstandard=20=
extension.=0D=0A>=20+=20*/=0D=0A>=20+=0D=0A>=20+enum=20fmp_crypto_algo_mode=
=20=7B=0D=0A>=20+=09FMP_BYPASS_MODE=20=3D=200,=0D=0A>=20+=09FMP_ALGO_MODE_A=
ES_CBC=20=3D=201,=0D=0A>=20+=09FMP_ALGO_MODE_AES_XTS=20=3D=202,=0D=0A>=20+=
=7D;=0D=0A>=20+enum=20fmp_crypto_key_length=20=7B=0D=0A>=20+=09FMP_KEYLEN_2=
56BIT=20=3D=201,=0D=0A>=20+=7D;=0D=0A>=20+=0D=0A>=20+/**=0D=0A>=20+=20*=20s=
truct=20fmp_sg_entry=20-=20nonstandard=20format=20of=20PRDT=20entries=20whe=
n=20FMP=20is=0D=0A>=20+enabled=0D=0A>=20+=20*=0D=0A>=20+=20*=20=40base:=20T=
he=20standard=20PRDT=20entry,=20but=20with=20nonstandard=20bitfields=20in=
=20the=0D=0A>=20high=0D=0A>=20+=20*=09bits=20of=20the=20'size'=20field,=20i=
.e.=20the=20last=2032-bit=20word.=20=20When=20these=0D=0A>=20+=20*=09nonsta=
ndard=20bitfields=20are=20zero,=20the=20data=20segment=20won't=20be=20encry=
pted=0D=0A>=20or=0D=0A>=20+=20*=09decrypted.=20=20Otherwise=20they=20specif=
y=20the=20algorithm=20and=20key=20length=20with=0D=0A>=20+=20*=09which=20th=
e=20data=20segment=20will=20be=20encrypted=20or=20decrypted.=0D=0A>=20+=20*=
=20=40file_iv:=20The=20initialization=20vector=20(IV)=20with=20all=20bytes=
=20reversed=0D=0A>=20+=20*=20=40file_enckey:=20The=20first=20half=20of=20th=
e=20AES-XTS=20key=20with=20all=20bytes=0D=0A>=20+reserved=0D=0A>=20+=20*=20=
=40file_twkey:=20The=20second=20half=20of=20the=20AES-XTS=20key=20with=20al=
l=20bytes=0D=0A>=20+reserved=0D=0A>=20+=20*=20=40disk_iv:=20Unused=0D=0A>=
=20+=20*=20=40reserved:=20Unused=0D=0A>=20+=20*/=0D=0A>=20+struct=20fmp_sg_=
entry=20=7B=0D=0A>=20+=09struct=20ufshcd_sg_entry=20base;=0D=0A>=20+=09__be=
64=20file_iv=5B2=5D;=0D=0A>=20+=09__be64=20file_enckey=5B4=5D;=0D=0A>=20+=
=09__be64=20file_twkey=5B4=5D;=0D=0A>=20+=09__be64=20disk_iv=5B2=5D;=0D=0A>=
=20+=09__be64=20reserved=5B2=5D;=0D=0A>=20+=7D;=0D=0A>=20+=0D=0A>=20+=23def=
ine=20SMC_CMD_FMP_SECURITY=09=5C=0D=0A>=20+=09ARM_SMCCC_CALL_VAL(ARM_SMCCC_=
FAST_CALL,=0D=0A>=20ARM_SMCCC_SMC_64,=20=5C=0D=0A>=20+=09=09=09=20=20=20ARM=
_SMCCC_OWNER_SIP,=200x1810)=0D=0A>=20+=23define=20SMC_CMD_SMU=09=09=5C=0D=
=0A>=20+=09ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,=0D=0A>=20ARM_SMCCC_SMC_6=
4,=20=5C=0D=0A>=20+=09=09=09=20=20=20ARM_SMCCC_OWNER_SIP,=200x1850)=0D=0A>=
=20+=23define=20SMC_CMD_FMP_SMU_RESUME=09=5C=0D=0A>=20+=09ARM_SMCCC_CALL_VA=
L(ARM_SMCCC_FAST_CALL,=0D=0A>=20ARM_SMCCC_SMC_64,=20=5C=0D=0A>=20+=09=09=09=
=20=20=20ARM_SMCCC_OWNER_SIP,=200x1860)=0D=0A>=20+=23define=20SMU_EMBEDDED=
=09=09=090=0D=0A>=20+=23define=20SMU_INIT=09=09=090=0D=0A>=20+=23define=20C=
FG_DESCTYPE_3=09=09=093=0D=0A>=20+=0D=0A>=20+static=20void=20exynos_ufs_fmp=
_init(struct=20ufs_hba=20*hba,=20struct=20exynos_ufs=0D=0A>=20+*ufs)=20=7B=
=0D=0A>=20+=09struct=20blk_crypto_profile=20*profile=20=3D=20&hba->crypto_p=
rofile;=0D=0A>=20+=09struct=20arm_smccc_res=20res;=0D=0A>=20+=09int=20err;=
=0D=0A>=20+=0D=0A>=20+=09/*=0D=0A>=20+=09=20*=20Check=20for=20the=20standar=
d=20crypto=20support=20bit,=20since=20it's=20available=20even=0D=0A>=20+=09=
=20*=20though=20the=20rest=20of=20the=20interface=20to=20FMP=20is=20nonstan=
dard.=0D=0A>=20+=09=20*=0D=0A>=20+=09=20*=20This=20check=20should=20have=20=
the=20effect=20of=20preventing=20the=20driver=20from=0D=0A>=20+=09=20*=20tr=
ying=20to=20use=20FMP=20on=20old=20Exynos=20SoCs=20that=20don't=20have=20FM=
P.=0D=0A>=20+=09=20*/=0D=0A>=20+=09if=20(=21(ufshcd_readl(hba,=20REG_CONTRO=
LLER_CAPABILITIES)=20&=0D=0A>=20+=09=20=20=20=20=20=20MASK_CRYPTO_SUPPORT))=
=0D=0A>=20+=09=09return;=0D=0A>=20+=0D=0A>=20+=09/*=0D=0A>=20+=09=20*=20The=
=20below=20sequence=20of=20SMC=20calls=20to=20enable=20FMP=20can=20be=20fou=
nd=20in=0D=0A>=20the=0D=0A>=20+=09=20*=20downstream=20driver=20source=20for=
=20gs101=20and=20other=20Exynos-based=20SoCs.=0D=0A>=20It=0D=0A>=20+=09=20*=
=20is=20the=20only=20way=20to=20enable=20FMP=20that=20works=20on=20SoCs=20s=
uch=20as=20gs101=0D=0A>=20that=0D=0A>=20+=09=20*=20don't=20make=20the=20FMP=
=20registers=20accessible=20to=20Linux.=20=20It=20probably=0D=0A>=20works=
=0D=0A>=20+=09=20*=20on=20other=20Exynos-based=20SoCs=20too,=20and=20might=
=20even=20still=20be=20the=20only=0D=0A>=20way=0D=0A>=20+=09=20*=20that=20w=
orks.=20=20But=20this=20hasn't=20been=20properly=20tested,=20and=20this=20c=
ode=20is=0D=0A>=20+=09=20*=20mutually=20exclusive=20with=20exynos_ufs_confi=
g_smu().=20=20So=20for=20now=0D=0A>=20only=0D=0A>=20+=09=20*=20enable=20FMP=
=20support=20on=20SoCs=20with=0D=0A>=20EXYNOS_UFS_OPT_UFSPR_SECURE.=0D=0A>=
=20+=09=20*/=0D=0A>=20+=09if=20(=21(ufs->opts=20&=20EXYNOS_UFS_OPT_UFSPR_SE=
CURE))=0D=0A>=20+=09=09return;=0D=0A>=20+=0D=0A>=20+=09/*=0D=0A>=20+=09=20*=
=20This=20call=20(which=20sets=20DESCTYPE=20to=200x3=20in=20the=20FMPSECURI=
TY0=0D=0A>=20register)=0D=0A>=20+=09=20*=20is=20needed=20to=20make=20the=20=
hardware=20use=20the=20larger=20PRDT=20entry=20size.=0D=0A>=20+=09=20*/=0D=
=0A>=20+=09BUILD_BUG_ON(sizeof(struct=20fmp_sg_entry)=20=21=3D=20128);=0D=
=0A>=20+=09arm_smccc_smc(SMC_CMD_FMP_SECURITY,=200,=20SMU_EMBEDDED,=0D=0A>=
=20CFG_DESCTYPE_3,=0D=0A>=20+=09=09=20=20=20=20=20=200,=200,=200,=200,=20&r=
es);=0D=0A>=20+=09if=20(res.a0)=20=7B=0D=0A>=20+=09=09dev_warn(hba->dev,=0D=
=0A>=20+=09=09=09=20=22SMC_CMD_FMP_SECURITY=20failed=20on=20init:=20%ld.=0D=
=0A>=20Disabling=20FMP=20support.=5Cn=22,=0D=0A>=20+=09=09=09=20res.a0);=0D=
=0A>=20+=09=09return;=0D=0A>=20+=09=7D=0D=0A>=20+=09ufshcd_set_sg_entry_siz=
e(hba,=20sizeof(struct=20fmp_sg_entry));=0D=0A>=20+=0D=0A>=20+=09/*=0D=0A>=
=20+=09=20*=20This=20is=20needed=20to=20initialize=20FMP.=20=20Without=20it=
,=20errors=20occur=20when=0D=0A>=20+=09=20*=20inline=20encryption=20is=20us=
ed.=0D=0A>=20+=09=20*/=0D=0A>=20+=09arm_smccc_smc(SMC_CMD_SMU,=20SMU_INIT,=
=20SMU_EMBEDDED,=200,=0D=0A>=200,=200,=200,=200,=20&res);=0D=0A>=20+=09if=
=20(res.a0)=20=7B=0D=0A>=20+=09=09dev_err(hba->dev,=0D=0A>=20+=09=09=09=22S=
MC_CMD_SMU(SMU_INIT)=20failed:=20%ld.=20=20Disabling=0D=0A>=20FMP=20support=
.=5Cn=22,=0D=0A>=20+=09=09=09res.a0);=0D=0A>=20+=09=09return;=0D=0A>=20+=09=
=7D=0D=0A>=20+=0D=0A>=20+=09/*=20Advertise=20crypto=20capabilities=20to=20t=
he=20block=20layer.=20*/=0D=0A>=20+=09err=20=3D=20devm_blk_crypto_profile_i=
nit(hba->dev,=20profile,=200);=0D=0A>=20+=09if=20(err)=20=7B=0D=0A>=20+=09=
=09/*=20Only=20ENOMEM=20should=20be=20possible=20here.=20*/=0D=0A>=20+=09=
=09dev_err(hba->dev,=20=22Failed=20to=20initialize=20crypto=20profile:=20%d=
=5Cn=22,=0D=0A>=20+=09=09=09err);=0D=0A>=20+=09=09return;=0D=0A>=20+=09=7D=
=0D=0A>=20+=09profile->max_dun_bytes_supported=20=3D=20AES_BLOCK_SIZE;=0D=
=0A>=20+=09profile->dev=20=3D=20hba->dev;=0D=0A>=20+=09profile-=0D=0A>=20>m=
odes_supported=5BBLK_ENCRYPTION_MODE_AES_256_XTS=5D=20=3D=0D=0A>=20+=09=09D=
ATA_UNIT_SIZE;=0D=0A>=20+=0D=0A>=20+=09/*=20Advertise=20crypto=20support=20=
to=20ufshcd-core.=20*/=0D=0A>=20+=09hba->caps=20=7C=3D=20UFSHCD_CAP_CRYPTO;=
=0D=0A>=20+=0D=0A>=20+=09/*=20Advertise=20crypto=20quirks=20to=20ufshcd-cor=
e.=20*/=0D=0A>=20+=09hba->quirks=20=7C=3D=20UFSHCD_QUIRK_CUSTOM_CRYPTO_PROF=
ILE=20=7C=0D=0A>=20+=09=09=20=20=20=20=20=20=20UFSHCD_QUIRK_BROKEN_CRYPTO_E=
NABLE=20=7C=0D=0A>=20+=09=09=20=20=20=20=20=20=20UFSHCD_QUIRK_KEYS_IN_PRDT;=
=0D=0A>=20+=0D=0A>=20+=7D=0D=0A>=20+=0D=0A>=20+static=20void=20exynos_ufs_f=
mp_resume(struct=20ufs_hba=20*hba)=20=7B=0D=0A>=20+=09struct=20arm_smccc_re=
s=20res;=0D=0A>=20+=0D=0A>=20+=09arm_smccc_smc(SMC_CMD_FMP_SECURITY,=200,=
=20SMU_EMBEDDED,=0D=0A>=20CFG_DESCTYPE_3,=0D=0A>=20+=09=09=20=20=20=20=20=
=200,=200,=200,=200,=20&res);=0D=0A>=20+=09if=20(res.a0)=0D=0A>=20+=09=09de=
v_err(hba->dev,=0D=0A>=20+=09=09=09=22SMC_CMD_FMP_SECURITY=20failed=20on=20=
resume:=0D=0A>=20%ld=5Cn=22,=20res.a0);=0D=0A>=20+=0D=0A>=20+=09arm_smccc_s=
mc(SMC_CMD_FMP_SMU_RESUME,=200,=0D=0A>=20SMU_EMBEDDED,=200,=200,=200,=200,=
=200,=0D=0A>=20+=09=09=20=20=20=20=20=20&res);=0D=0A>=20+=09if=20(res.a0)=
=0D=0A>=20+=09=09dev_err(hba->dev,=0D=0A>=20+=09=09=09=22SMC_CMD_FMP_SMU_RE=
SUME=20failed:=20%ld=5Cn=22,=0D=0A>=20res.a0);=20=7D=0D=0A>=20+=0D=0A>=20+s=
tatic=20inline=20__be64=20fmp_key_word(const=20u8=20*key,=20int=20j)=20=7B=
=0D=0A>=20+=09return=20cpu_to_be64(get_unaligned_le64(=0D=0A>=20+=09=09=09k=
ey=20+=20AES_KEYSIZE_256=20-=20(j=20+=201)=20*=20sizeof(u64)));=20=7D=0D=0A=
>=20+=0D=0A>=20+/*=20Fill=20the=20PRDT=20for=20a=20request=20according=20to=
=20the=20given=20encryption=0D=0A>=20+context.=20*/=20static=20int=20exynos=
_ufs_fmp_fill_prdt(struct=20ufs_hba=20*hba,=0D=0A>=20+=09=09=09=09=20=20=20=
=20const=20struct=20bio_crypt_ctx=20*crypt_ctx,=0D=0A>=20+=09=09=09=09=20=
=20=20=20void=20*prdt,=20unsigned=20int=20num_segments)=20=7B=0D=0A>=20+=09=
struct=20fmp_sg_entry=20*fmp_prdt=20=3D=20prdt;=0D=0A>=20+=09const=20u8=20*=
enckey=20=3D=20crypt_ctx->bc_key->raw;=0D=0A>=20+=09const=20u8=20*twkey=20=
=3D=20enckey=20+=20AES_KEYSIZE_256;=0D=0A>=20+=09u64=20dun_lo=20=3D=20crypt=
_ctx->bc_dun=5B0=5D;=0D=0A>=20+=09u64=20dun_hi=20=3D=20crypt_ctx->bc_dun=5B=
1=5D;=0D=0A>=20+=09unsigned=20int=20i;=0D=0A>=20+=0D=0A>=20+=09/*=20If=20FM=
P=20wasn't=20enabled,=20we=20shouldn't=20get=20any=20encrypted=20requests.=
=0D=0A>=20*/=0D=0A>=20+=09if=20(WARN_ON_ONCE(=21(hba->caps=20&=20UFSHCD_CAP=
_CRYPTO)))=0D=0A>=20+=09=09return=20-EIO;=0D=0A>=20+=0D=0A>=20+=09/*=20Conf=
igure=20FMP=20on=20each=20segment=20of=20the=20request.=20*/=0D=0A>=20+=09f=
or=20(i=20=3D=200;=20i=20<=20num_segments;=20i++)=20=7B=0D=0A>=20+=09=09str=
uct=20fmp_sg_entry=20*prd=20=3D=20&fmp_prdt=5Bi=5D;=0D=0A>=20+=09=09int=20j=
;=0D=0A>=20+=0D=0A>=20+=09=09/*=20Each=20segment=20must=20be=20exactly=20on=
e=20data=20unit.=20*/=0D=0A>=20+=09=09if=20(prd->base.size=20=21=3D=20cpu_t=
o_le32(DATA_UNIT_SIZE=20-=201))=20=7B=0D=0A>=20+=09=09=09dev_err(hba->dev,=
=0D=0A>=20+=09=09=09=09=22data=20segment=20is=20misaligned=20for=20FMP=5Cn=
=22);=0D=0A>=20+=09=09=09return=20-EIO;=0D=0A>=20+=09=09=7D=0D=0A>=20+=0D=
=0A>=20+=09=09/*=20Set=20the=20algorithm=20and=20key=20length.=20*/=0D=0A>=
=20+=09=09prd->base.size=20=7C=3D=0D=0A>=20cpu_to_le32((FMP_ALGO_MODE_AES_X=
TS=20<<=2028)=20=7C=0D=0A>=20+=09=09=09=09=09=20=20=20=20=20=20(FMP_KEYLEN_=
256BIT=20<<=2026));=0D=0A>=20+=0D=0A>=20+=09=09/*=20Set=20the=20IV.=20*/=0D=
=0A>=20+=09=09prd->file_iv=5B0=5D=20=3D=20cpu_to_be64(dun_hi);=0D=0A>=20+=
=09=09prd->file_iv=5B1=5D=20=3D=20cpu_to_be64(dun_lo);=0D=0A>=20+=0D=0A>=20=
+=09=09/*=20Set=20the=20key.=20*/=0D=0A>=20+=09=09for=20(j=20=3D=200;=20j=
=20<=20AES_KEYSIZE_256=20/=20sizeof(u64);=20j++)=20=7B=0D=0A>=20+=09=09=09p=
rd->file_enckey=5Bj=5D=20=3D=20fmp_key_word(enckey,=20j);=0D=0A>=20+=09=09=
=09prd->file_twkey=5Bj=5D=20=3D=20fmp_key_word(twkey,=20j);=0D=0A>=20+=09=
=09=7D=0D=0A>=20+=0D=0A>=20+=09=09/*=20Increment=20the=20data=20unit=20numb=
er.=20*/=0D=0A>=20+=09=09dun_lo++;=0D=0A>=20+=09=09if=20(dun_lo=20=3D=3D=20=
0)=0D=0A>=20+=09=09=09dun_hi++;=0D=0A>=20+=09=7D=0D=0A>=20+=09return=200;=
=0D=0A>=20+=7D=0D=0A>=20+=0D=0A>=20+=23else=20/*=20CONFIG_SCSI_UFS_CRYPTO=
=20*/=0D=0A>=20+=0D=0A>=20+static=20void=20exynos_ufs_fmp_init(struct=20ufs=
_hba=20*hba,=20struct=20exynos_ufs=0D=0A>=20+*ufs)=20=7B=20=7D=0D=0A>=20+=
=0D=0A>=20+static=20void=20exynos_ufs_fmp_resume(struct=20ufs_hba=20*hba)=
=20=7B=20=7D=0D=0A>=20+=0D=0A>=20+=23define=20exynos_ufs_fmp_fill_prdt=20NU=
LL=0D=0A>=20+=0D=0A>=20+=23endif=20/*=20=21CONFIG_SCSI_UFS_CRYPTO=20*/=0D=
=0A>=20+=0D=0A>=20=20static=20int=20exynos_ufs_init(struct=20ufs_hba=20*hba=
)=20=20=7B=0D=0A>=20=20=09struct=20device=20*dev=20=3D=20hba->dev;=0D=0A>=
=20=20=09struct=20platform_device=20*pdev=20=3D=20to_platform_device(dev);=
=0D=0A>=20=20=09struct=20exynos_ufs=20*ufs;=0D=0A>=20=40=40=20-1196,10=20+1=
421,12=20=40=40=20static=20int=20exynos_ufs_init(struct=20ufs_hba=20*hba)=
=0D=0A>=20=20=09=09goto=20out;=0D=0A>=20=20=09=7D=0D=0A>=20=0D=0A>=20=20=09=
exynos_ufs_priv_init(hba,=20ufs);=0D=0A>=20=0D=0A>=20+=09exynos_ufs_fmp_ini=
t(hba,=20ufs);=0D=0A>=20+=0D=0A>=20=20=09if=20(ufs->drv_data->drv_init)=20=
=7B=0D=0A>=20=20=09=09ret=20=3D=20ufs->drv_data->drv_init(dev,=20ufs);=0D=
=0A>=20=20=09=09if=20(ret)=20=7B=0D=0A>=20=20=09=09=09dev_err(dev,=20=22fai=
led=20to=20init=20drv-data=5Cn=22);=0D=0A>=20=20=09=09=09goto=20out;=0D=0A>=
=20=40=40=20-1211,11=20+1438,11=20=40=40=20static=20int=20exynos_ufs_init(s=
truct=20ufs_hba=20*hba)=0D=0A>=20=20=09=09goto=20out;=0D=0A>=20=20=09exynos=
_ufs_specify_phy_time_attr(ufs);=0D=0A>=20=20=09if=20(=21(ufs->opts=20&=20E=
XYNOS_UFS_OPT_UFSPR_SECURE))=0D=0A>=20=20=09=09exynos_ufs_config_smu(ufs);=
=0D=0A>=20=0D=0A>=20-=09hba->host->dma_alignment=20=3D=20SZ_4K=20-=201;=0D=
=0A>=20+=09hba->host->dma_alignment=20=3D=20DATA_UNIT_SIZE=20-=201;=0D=0ASa=
me=20comment=20as=20above.=0D=0A=0D=0A>=20=20=09return=200;=0D=0A>=20=0D=0A=
>=20=20out:=0D=0A>=20=20=09hba->priv=20=3D=20NULL;=0D=0A>=20=20=09return=20=
ret;=0D=0A>=20=40=40=20-1330,11=20+1557,11=20=40=40=20static=20int=20exynos=
_ufs_hce_enable_notify(struct=0D=0A>=20ufs_hba=20*hba,=0D=0A>=20=20=09=09=
=20*=20The=20maximum=20segment=20size=20must=20be=20set=20after=0D=0A>=20sc=
si_host_alloc()=0D=0A>=20=20=09=09=20*=20has=20been=20called=20and=20before=
=20LUN=20scanning=20starts=0D=0A>=20=20=09=09=20*=20(ufshcd_async_scan()).=
=20Note:=20this=20callback=20may=20also=20be=0D=0A>=20called=0D=0A>=20=20=
=09=09=20*=20from=20other=20functions=20than=20ufshcd_init().=0D=0A>=20=20=
=09=09=20*/=0D=0A>=20-=09=09hba->host->max_segment_size=20=3D=20SZ_4K;=0D=
=0A>=20+=09=09hba->host->max_segment_size=20=3D=20DATA_UNIT_SIZE;=0D=0AAnd=
=20here.=0D=0A=0D=0A=0D=0A>=20=0D=0A>=20=20=09=09if=20(ufs->drv_data->pre_h=
ce_enable)=20=7B=0D=0A>=20=20=09=09=09ret=20=3D=20ufs->drv_data->pre_hce_en=
able(ufs);=0D=0A>=20=20=09=09=09if=20(ret)=0D=0A>=20=20=09=09=09=09return=
=20ret;=0D=0A>=20=40=40=20-1430,11=20+1657,11=20=40=40=20static=20int=20exy=
nos_ufs_resume(struct=20ufs_hba=0D=0A>=20*hba,=20enum=20ufs_pm_op=20pm_op)=
=0D=0A>=20=0D=0A>=20=20=09if=20(=21ufshcd_is_link_active(hba))=0D=0A>=20=20=
=09=09phy_power_on(ufs->phy);=0D=0A>=20=0D=0A>=20=20=09exynos_ufs_config_sm=
u(ufs);=0D=0A>=20-=0D=0A>=20+=09exynos_ufs_fmp_resume(hba);=0D=0A>=20=20=09=
return=200;=0D=0A>=20=20=7D=0D=0A>=20=0D=0A>=20=20static=20int=20exynosauto=
_ufs_vh_link_startup_notify(struct=20ufs_hba=20*hba,=0D=0A>=20=20=09=09=09=
=09=09=09=20enum=0D=0A>=20ufs_notify_change_status=20status)=20=40=40=20-16=
96,10=20+1923,11=20=40=40=20static=20const=0D=0A>=20struct=20ufs_hba_varian=
t_ops=20ufs_hba_exynos_ops=20=3D=20=7B=0D=0A>=20=20=09.setup_xfer_req=09=09=
=09=3D=0D=0A>=20exynos_ufs_specify_nexus_t_xfer_req,=0D=0A>=20=20=09.setup_=
task_mgmt=09=09=3D=0D=0A>=20exynos_ufs_specify_nexus_t_tm_req,=0D=0A>=20=20=
=09.hibern8_notify=09=09=09=3D=0D=0A>=20exynos_ufs_hibern8_notify,=0D=0A>=
=20=20=09.suspend=09=09=09=3D=20exynos_ufs_suspend,=0D=0A>=20=20=09.resume=
=09=09=09=09=3D=20exynos_ufs_resume,=0D=0A>=20+=09.fill_crypto_prdt=09=09=
=3D=20exynos_ufs_fmp_fill_prdt,=0D=0A>=20=20=7D;=0D=0A>=20=0D=0A>=20=20stat=
ic=20struct=20ufs_hba_variant_ops=20ufs_hba_exynosauto_vh_ops=20=3D=20=7B=
=0D=0A>=20=20=09.name=09=09=09=09=3D=20=22exynosauto_ufs_vh=22,=0D=0A>=20=
=20=09.init=09=09=09=09=3D=20exynosauto_ufs_vh_init,=0D=0A>=20--=0D=0A>=202=
.45.2=0D=0A=0D=0A=0D=0A

