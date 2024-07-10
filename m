Return-Path: <linux-fscrypt+bounces-346-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D42B492CA59
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 08:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA9E41C22118
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 06:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94EB91B86FC;
	Wed, 10 Jul 2024 06:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WGXLFS1U"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3EDA47
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720591580; cv=none; b=gZesUk9VYATu69UGo9QzDiUlKBNxidHFxzZFvvbw1/PvieJ52JZh+WooaTBiOaHVR+9SkKWdk9aCUdVBw7B0gnwn2UXZYcGkm7VQBg7mXpxAzQXBMcSKpW1VzKgF3MaSA9EeRH1e6Mt1hAL9cYKN0noeQjTMjLC+M4HeUTHNUFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720591580; c=relaxed/simple;
	bh=hTpjYCHG8VMmzbak/zpl1eQ5zHg2em7wjcg5XoYouZk=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=uCwNj3ZSLWuKEWXflzFK3spzNq/KuSAEPOLdaEXcO3HZFPuMniPosxgHD0Kz5gZBLmxe0BjbwWvWPptAUYOBVoVIL0U3eQKW5Zz4Lv2dyKUATooIbsMQRRfmiWlCeIsbTuillXJutqat5uZlX6fdsyngO5rRB1DMMu9x2EO6+28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WGXLFS1U; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240710060615epoutp02820b60d3fcc53bf9d13721b75323de2f~gxOvstj1n2450924509epoutp02j
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 06:06:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240710060615epoutp02820b60d3fcc53bf9d13721b75323de2f~gxOvstj1n2450924509epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720591575;
	bh=hTpjYCHG8VMmzbak/zpl1eQ5zHg2em7wjcg5XoYouZk=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=WGXLFS1UjSVIFCzd3zXcuLj8WtcpXecz+M5495BqS9Dt4wilU9+1+7mtcgVicb2Ax
	 MqKy7xo4j2lsQ4BTwhV+8is1ubibN28Sy8YDijJMgLEqTIwHmIr1CButhrPUIR56ko
	 cWNzG2UJJGCXTxD3e2sX53DbB12Da9JAhlXY8pMU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240710060614epcas5p382ba4d015dfce8e6796a5f50f9944954~gxOvXRHT90202102021epcas5p3T;
	Wed, 10 Jul 2024 06:06:14 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4WJnRT0GqFz4x9Pw; Wed, 10 Jul
	2024 06:06:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D0.55.11095.4D42E866; Wed, 10 Jul 2024 15:06:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240710060612epcas5p3ca85e22e772fb84752383974e4604267~gxOtSe9rA0202102021epcas5p3F;
	Wed, 10 Jul 2024 06:06:12 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240710060612epsmtrp17c28b47096440a2e588394f6e0e48bab~gxOtRgRga0085300853epsmtrp1G;
	Wed, 10 Jul 2024 06:06:12 +0000 (GMT)
X-AuditID: b6c32a49-3c3ff70000012b57-de-668e24d4f5e5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	21.02.18846.4D42E866; Wed, 10 Jul 2024 15:06:12 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710060611epsmtip217de329399b79a0e8e693196d3a1691f~gxOr2KGs50965309653epsmtip2-;
	Wed, 10 Jul 2024 06:06:10 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-samsung-soc@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	"'Avri Altman'" <avri.altman@wdc.com>, "'Bart	Van Assche'"
	<bvanassche@acm.org>, "'Martin K . Petersen'" <martin.petersen@oracle.com>,
	"'Peter Griffin'" <peter.griffin@linaro.org>,
	=?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'William
 McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708235330.103590-2-ebiggers@kernel.org>
Subject: RE: [PATCH v3 1/6] scsi: ufs: core: Add
 UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
Date: Wed, 10 Jul 2024 11:36:09 +0530
Message-ID: <017f01dad28f$43e728f0$cbb57ad0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHC4eaVKc/l097EGvITZfSx67wqzAKrIG/0AmlCDgex9rcgUA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmlu4Vlb40g9YOC4strzazWLz8eZXN
	YtqHn8wWa/f8YbZ4Ne8bi8WM8/uYLLqv72CzWH78H5PFhhn/WCxWffrP6MDlcfmKt8eCTaUe
	m1Z1snncubaHzePj01ssHp83yXm0H+hmCmCPyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUz
	MNQ1tLQwV1LIS8xNtVVy8QnQdcvMAbpOSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQ
	klNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdsXHuAvaCp3wV6yfdYm1gbOPrYuTkkBAwkej5
	d4ali5GLQ0hgN6PE6ovvmUESQgKfGCWez8+ESADZy67fZ4fp+NJ+ixGiaCejxPYZRRBFLxgl
	Nq17BNbNJqArsWNxGxuILSLgIXG+/yJYM7PAFyaJdy/UQWxOASuJ69N7WUBsYYFQiRnrjoLZ
	LAKqEjsv7wCyOTh4BSwljs+IBAnzCghKnJz5hAVijLbEsoWvmSHuUZD4+XQZK0i5iICTxKl1
	GhAl4hIvjx5hBzlNQmAth8SdM5fZQWokBFwkpt8Kg2gVlnh1fAvUW1ISL/vboOxsieMXZ7FB
	2BUS3a0foeL2Ejsf3QS7jFlAU2L9Ln2IVXwSvb+fMEFM55XoaBOCqFaVaH53lQXClpaY2N3N
	ClHiIbGomXUCo+IsJG/NQvLWLCT3z0LYtYCRZRWjZGpBcW56arFpgWFeajk8qpPzczcxgpOt
	lucOxrsPPugdYmTiYDzEKMHBrCTCO/9Gd5oQb0piZVVqUX58UWlOavEhRlNgUE9klhJNzgem
	+7ySeEMTSwMTMzMzE0tjM0Mlcd7XrXNThATSE0tSs1NTC1KLYPqYODilGph4dj6ZbtDl0squ
	pN0l4vxz1sRjMzfslNRoXinAFGan8W/l731+fq88uv5Pyl6jIVBfuPaJ+ZufO1nilO3z7b9s
	urRdr/yk0ET/g6cv54nleXTfqTt9POddtaXY7HKe/zwRM9tLniqF5Altkw75dbnLqkojO/b8
	4bk8c7nOz089nJW/c5H4yyRJz//7Lh7eyCY5S0ztUktj0eITaes8pD4s3aO++OG9rNOTCo4s
	M60rV7xg8vB0U+PFd+eeZFWp7F37mD2O9d/x1WmrXSMN7c+Ln48Qe17UJsbBuTA07LdyNlPU
	/v4N8zQbpD86KDG4njXqCXxmaRIi3v00trZSvyV4b3V83DZuH83vHhN2WyqxFGckGmoxFxUn
	AgALYUtaPwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvO4Vlb40g0d7FC22vNrMYvHy51U2
	i2kffjJbrN3zh9ni1bxvLBYzzu9jsui+voPNYvnxf0wWG2b8Y7FY9ek/owOXx+Ur3h4LNpV6
	bFrVyeZx59oeNo+PT2+xeHzeJOfRfqCbKYA9issmJTUnsyy1SN8ugSvjyK0OxoIV3BXtfx4w
	NzDu4uxi5OSQEDCR+NJ+i7GLkYtDSGA7o8T1zjY2iIS0xPWNE9ghbGGJlf+es0MUPWOUaFpx
	DKyITUBXYsdiiAYRAS+JrtZJLCBFzAI/mCT+rjwKNXYno8TdKxtYQKo4Bawkrk/vBbOFBYIl
	ri3bDLaCRUBVYuflHUBxDg5eAUuJ4zMiQcK8AoISJ2c+AStnFtCWeHrzKZy9bOFrZojrFCR+
	Pl3GCtIqIuAkcWqdBkSJuMTLo0fYJzAKz0IyaRaSSbOQTJqFpGUBI8sqRtHUguLc9NzkAkO9
	4sTc4tK8dL3k/NxNjOCo0wrawbhs/V+9Q4xMHIyHGCU4mJVEeOff6E4T4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkzquc05kiJJCeWJKanZpakFoEk2Xi4JRqYJLaKb239HBf1QOz+S7XKh2lvSdo
	ee5S57oWu0Go76JVyt3EP7kNomEZmo/NJ3N4K+zT/SC+5MuZVVofRTZMPz/RemnXnPjWn2Kf
	22/9/zy7ZEen1YuvDVOUxdZOT/er8S6ZtG2KZdbRhrbfToZq9x1uifYZ3hdPjX002+jDws3n
	oheLyapuX/FofZdlUKBXA3Mls2DrbjGF8/OeuB48mGof1W9/V7ThxnXxR6JXSgrnTtyRunvx
	Ja6ZR+NS5A5PLnJMFPNkLD/sd1dyx7kzy971ifPvi8/J23/c+5LI1tcstrnHv9865n++/tY5
	neZDhs6T1Nc2rus9MPGs5dl/3ML2sTJcAXlFPeuU8pJTcpVYijMSDbWYi4oTAfXswGIpAwAA
X-CMS-MailID: 20240710060612epcas5p3ca85e22e772fb84752383974e4604267
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708235538epcas5p288a8b25fdf2e59b233449a897b406034
References: <20240708235330.103590-1-ebiggers@kernel.org>
	<CGME20240708235538epcas5p288a8b25fdf2e59b233449a897b406034@epcas5p2.samsung.com>
	<20240708235330.103590-2-ebiggers@kernel.org>



> -----Original Message-----
> From: Eric Biggers <ebiggers=40kernel.org>
> Sent: Tuesday, July 9, 2024 5:23 AM
> To: linux-scsi=40vger.kernel.org
> Cc: linux-samsung-soc=40vger.kernel.org; linux-fscrypt=40vger.kernel.org;=
 Alim
> Akhtar <alim.akhtar=40samsung.com>; Avri Altman <avri.altman=40wdc.com>;
> Bart Van Assche <bvanassche=40acm.org>; Martin K . Petersen
> <martin.petersen=40oracle.com>; Peter Griffin <peter.griffin=40linaro.org=
>;
> Andr=C3=A9=20Draszik=20<andre.draszik=40linaro.org>;=20William=20McVicker=
=0D=0A>=20<willmcvicker=40google.com>=0D=0A>=20Subject:=20=5BPATCH=20v3=201=
/6=5D=20scsi:=20ufs:=20core:=20Add=0D=0A>=20UFSHCD_QUIRK_CUSTOM_CRYPTO_PROF=
ILE=0D=0A>=20=0D=0A>=20From:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=
=0A>=20=0D=0A>=20Add=20UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE=20which=20lets=20=
UFS=20host=20drivers=0D=0A>=20initialize=20the=20blk_crypto_profile=20thems=
elves=20rather=20than=20have=20it=20be=20initialized=0D=0A>=20by=20ufshcd-c=
ore=20according=20to=20the=20UFSHCI=20standard.=20=20This=20is=20needed=20t=
o=20support=0D=0A>=20inline=20encryption=20on=20the=20=22Exynos=22=20UFS=20=
controller=20which=20has=20a=20nonstandard=0D=0A>=20interface.=0D=0A>=20=0D=
=0A>=20Reviewed-by:=20Bart=20Van=20Assche=20<bvanassche=40acm.org>=0D=0A>=
=20Reviewed-by:=20Peter=20Griffin=20<peter.griffin=40linaro.org>=0D=0A>=20S=
igned-off-by:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=0A>=20---=0D=0A=
=0D=0AReviewed-by:=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>=0D=0A=0D=
=0A>=20=20drivers/ufs/core/ufshcd-crypto.c=20=7C=2010=20+++++++---=0D=0A>=
=20=20include/ufs/ufshcd.h=20=20=20=20=20=20=20=20=20=20=20=20=20=7C=20=209=
=20+++++++++=0D=0A>=20=202=20files=20changed,=2016=20insertions(+),=203=20d=
eletions(-)=0D=0A>=20=0D=0A=5BSnip=5D=09=09=09=09=3D=201=20<<=200,=0D=0A>=
=20--=0D=0A>=202.45.2=0D=0A=0D=0A=0D=0A

