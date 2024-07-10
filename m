Return-Path: <linux-fscrypt+bounces-348-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6818792CC21
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 09:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 885E41C213C4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 07:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5170379B7E;
	Wed, 10 Jul 2024 07:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VFlfcrH0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988A828DC1
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 07:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720597367; cv=none; b=iXu6Jgjbpe8VUAxOXs0O41cjkI3ZXL+Whlz/ehNS6Mz+IxTbQcbaP7iPnE9roLzF7y+WnLcYoIbBUEH4sRWkmeVqx0c7OaKV8WzjgcyDGTwlT8yhWbVqQ1EsAtQ1W7DFbjspg3IzwsEzSOvnRHlC/q16YwDXKYcAEOPvzVORRA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720597367; c=relaxed/simple;
	bh=a0ekuZJJ/YLF9Qp4rvUzveCQ0KgwDGePsF5YNkFu5Xo=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=cdIiL2pM0K2nJEV+qSWl1ESNMTVByv2HCpC20oALl5kq32oDluPUErFUbmP5R64L8mTdcdIdX7MyZmRkyXsU3POyK6/7k2GxK2JNFyJcmJ7E5xv8UHwKioktLJl0gPCkvQAZPDwqatYR+a2Hbs7JNV9STphUM4aN0xHgq67+t8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VFlfcrH0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240710074241epoutp04037a5a71fc45758d17a5f5221854ecd6~gyi87gcm11117811178epoutp04I
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 07:42:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240710074241epoutp04037a5a71fc45758d17a5f5221854ecd6~gyi87gcm11117811178epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720597361;
	bh=a0ekuZJJ/YLF9Qp4rvUzveCQ0KgwDGePsF5YNkFu5Xo=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=VFlfcrH0IuJ0qZ8A5F43onAEfinBG1hMsaxSmZjZQ8zE6Rj6aBT0PHKkJqVPS3dHm
	 dbhWVTDnmdvAXOuJsnBPLCaQVeTkhRiRptXran3EHA1htpe4F+30/a84yquKtt9zb7
	 0KulJ2Y58KJlCxHvnMTufVS2iEbupafgSSn8ke2w=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240710074241epcas5p1e9411bad693aa237f8f811544a5d84f5~gyi8OhElQ1014910149epcas5p1S;
	Wed, 10 Jul 2024 07:42:41 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WJqZl2wYNz4x9Pp; Wed, 10 Jul
	2024 07:42:39 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A3.3E.09989.F6B3E866; Wed, 10 Jul 2024 16:42:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240710074239epcas5p4d120cce9b203327c9648120b2202266a~gyi6VcEUF0590705907epcas5p4f;
	Wed, 10 Jul 2024 07:42:39 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240710074239epsmtrp151bdb90f5396b7be319941cfdb3e40ec~gyi6UugB22362023620epsmtrp1V;
	Wed, 10 Jul 2024 07:42:39 +0000 (GMT)
X-AuditID: b6c32a4a-bffff70000002705-ac-668e3b6f7bc0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F9.6D.29940.E6B3E866; Wed, 10 Jul 2024 16:42:38 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710074237epsmtip2a61a30e62ca093eab17748823cce85ed~gyi42KCtp0303403034epsmtip2U;
	Wed, 10 Jul 2024 07:42:37 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-samsung-soc@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	"'Avri Altman'" <avri.altman@wdc.com>, "'Bart	Van Assche'"
	<bvanassche@acm.org>, "'Martin K . Petersen'" <martin.petersen@oracle.com>,
	"'Peter Griffin'" <peter.griffin@linaro.org>,
	=?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'William
 McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708235330.103590-4-ebiggers@kernel.org>
Subject: RE: [PATCH v3 3/6] scsi: ufs: core: Add
 UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
Date: Wed, 10 Jul 2024 13:12:36 +0530
Message-ID: <018501dad29c$bcd7ee90$3687cbb0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHC4eaVKc/l097EGvITZfSx67wqzAIzfEJGAetj6Lqx/n6N8A==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIJsWRmVeSWpSXmKPExsWy7bCmum6+dV+awZzvwhZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAelW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUg
	JafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7o3PDJKaC3coVW/btYW1gnKHUxcjJISFgIrFi
	2VTmLkYuDiGB3YwS27uOsEE4nxglDjYuZwapEhL4xigxY6ksTMfbH/uhivYySty4vhjKecEo
	8ePEEXaQKjYBXYkdi9vYQGwRAQ+J8/0XweLMAl+YJN69UAexOQWsJO6fmMUEYgsLhEhcunKW
	EcRmEVCVeD9hKlg9r4ClxIE7m6FsQYmTM5+wQMzRlli28DUzxEUKEj+fLmOF2OUksWLTOzaI
	GnGJl0dB7uECqtnCIXFibjcbRIOLxO33C6BsYYlXx7ewQ9hSEi/726DsbInjF2dB1VRIdLd+
	hIrbS+x8dBPoCA6gBZoS63fpQ+zik+j9/YQJJCwhwCvR0SYEUa0q0fzuKguELS0xsbubFcL2
	kJi+sY1lAqPiLCSfzULy2SwkH8xCWLaAkWUVo2RqQXFuemqxaYFRXmo5PL6T83M3MYLTrpbX
	DsaHDz7oHWJk4mA8xCjBwawkwjv/RneaEG9KYmVValF+fFFpTmrxIUZTYHBPZJYSTc4HJv68
	knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYvNhc2CwzbohP/2zA
	2d++hi1jveTGzeGtelKzBZIrvxeslPMtEJjeW2rwa+mb6xzbw3ZX94RPfB7xdenMnQ96Wq18
	jKdcczCetlEjjqlm4XH+yL9TpnfozCoK7N5VE/Z/X3lMwntl3jL3fqENL9fmhz+ZfPDZi0L1
	1Yc6T7iVOR13ZdB9dHbG2QQO85rGYyo3moM2L0peHD33bVVXXY8dt3TI6r9ZMTNNmDXYDorc
	qvc6mCdyVnPt23jPNWqhDZO2R+evctKc93+7EedPI0X7RedXBLTOm8mu8rG3gdt9wqeq5wdE
	ZII8Dx3tnc1hPqN4ksiz9fHbdDknTT6mem97+LbOhefE+t5b87z+cd1aiaU4I9FQi7moOBEA
	Nawa10QEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSvG6edV+awauDlhZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAexWWTkpqTWZZapG+XwJXxfOZcxoKjkhUNGy0b
	GH+JdDFyckgImEi8/bGfrYuRi0NIYDejxOS5zawQCWmJ6xsnsEPYwhIr/z1nhyh6xihxsfsI
	WIJNQFdix+I2NhBbRMBLoqt1EgtIEbPADyaJvyuPMkJ07GSU6P21gAWkilPASuL+iVlMILaw
	QJDE2s1fwSaxCKhKvJ8wFczmFbCUOHBnM5QtKHFy5hOwXmYBbYmnN5/C2csWvmaGOE9B4ufT
	ZawQVzhJrNj0jg2iRlzi5dEj7BMYhWchGTULyahZSEbNQtKygJFlFaNkakFxbnpusWGBYV5q
	uV5xYm5xaV66XnJ+7iZGcPxpae5g3L7qg94hRiYOxkOMEhzMSiK88290pwnxpiRWVqUW5ccX
	leakFh9ilOZgURLnFX/RmyIkkJ5YkpqdmlqQWgSTZeLglGpgMnJo/sSi/sfYpU702U39H33m
	uWqayp/dt9xvXJv2ckuxfrBPTHa47Eo2/vMHd3xyVBTWtJpzijfV4M7uFpWDckGvXsV+azbr
	eJrwXMbFOldW80wZ44Zvt/5pdP4R12ri57nPOuVCwVTfI1EPFte8jmG+eEF3TsfPUy0LVYXL
	Z+SsjM8t993QEn3L/eqS17unpYrov9f+mLsi5ejCvn2Pz0TraCouWdt0cddWU9Wph7fcX70w
	4LTleTGVzrafmgx6kbqrkh72/M1TO3XxysurESIBbxmneP54pbGEY4n5WQu3Z0IZnw9XPjlm
	cyCPzYhN5fgxGR7/KClvPUnZXseWjaV9At7/Du59NWHzrH4pJZbijERDLeai4kQA9DcE2C4D
	AAA=
X-CMS-MailID: 20240710074239epcas5p4d120cce9b203327c9648120b2202266a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708235540epcas5p35738484c4f3e5884fa990f1aa3cd8a95
References: <20240708235330.103590-1-ebiggers@kernel.org>
	<CGME20240708235540epcas5p35738484c4f3e5884fa990f1aa3cd8a95@epcas5p3.samsung.com>
	<20240708235330.103590-4-ebiggers@kernel.org>



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
=0D=0A>=20<willmcvicker=40google.com>=0D=0A>=20Subject:=20=5BPATCH=20v3=203=
/6=5D=20scsi:=20ufs:=20core:=20Add=0D=0A>=20UFSHCD_QUIRK_BROKEN_CRYPTO_ENAB=
LE=0D=0A>=20=0D=0A>=20From:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=
=0A>=20=0D=0A>=20Add=20UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE=20which=20tells=20=
the=20UFS=20core=20to=0D=0A>=20not=20use=20the=20crypto=20enable=20bit=20de=
fined=20by=20the=20UFS=20specification.=20=20This=20is=0D=0A>=20needed=20to=
=20support=20inline=20encryption=20on=20the=20=22Exynos=22=20UFS=20controll=
er.=0D=0A>=20=0D=0A>=20Reviewed-by:=20Bart=20Van=20Assche=20<bvanassche=40a=
cm.org>=0D=0A>=20Reviewed-by:=20Peter=20Griffin=20<peter.griffin=40linaro.o=
rg>=0D=0A>=20Signed-off-by:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=
=0A>=20---=0D=0AReviewed-by:=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>=
=0D=0A=0D=0A>=20=20drivers/ufs/core/ufshcd-crypto.c=20=7C=208=20++++++++=0D=
=0A>=20=20include/ufs/ufshcd.h=20=20=20=20=20=20=20=20=20=20=20=20=20=7C=20=
7=20+++++++=0D=0A>=20=202=20files=20changed,=2015=20insertions(+)=0D=0A>=20=
=0D=0A>=20diff=20--git=20a/drivers/ufs/core/ufshcd-crypto.c=20b/drivers/ufs=
/core/ufshcd-=0D=0A>=20crypto.c=0D=0A>=20index=20b4980fd91cee..a714dad82cd1=
=20100644=0D=0A>=20---=20a/drivers/ufs/core/ufshcd-crypto.c=0D=0A>=20+++=20=
b/drivers/ufs/core/ufshcd-crypto.c=0D=0A>=20=40=40=20-108,17=20+108,25=20=
=40=40=20static=20int=20ufshcd_crypto_keyslot_evict(struct=0D=0A>=20blk_cry=
pto_profile=20*profile,=0D=0A>=20=20=09union=20ufs_crypto_cfg_entry=20cfg=
=20=3D=20=7B=7D;=0D=0A>=20=0D=0A>=20=20=09return=20ufshcd_program_key(hba,=
=20&cfg,=20slot);=20=20=7D=0D=0A>=20=0D=0A>=20+/*=0D=0A>=20+=20*=20Reprogra=
m=20the=20keyslots=20if=20needed,=20and=20return=20true=20if=0D=0A>=20+CRYP=
TO_GENERAL_ENABLE=0D=0A>=20+=20*=20should=20be=20used=20in=20the=20host=20c=
ontroller=20initialization=20sequence.=0D=0A>=20+=20*/=0D=0A>=20=20bool=20u=
fshcd_crypto_enable(struct=20ufs_hba=20*hba)=20=20=7B=0D=0A>=20=20=09if=20(=
=21(hba->caps=20&=20UFSHCD_CAP_CRYPTO))=0D=0A>=20=20=09=09return=20false;=
=0D=0A>=20=0D=0A>=20=20=09/*=20Reset=20might=20clear=20all=20keys,=20so=20r=
eprogram=20all=20the=20keys.=20*/=0D=0A>=20=20=09blk_crypto_reprogram_all_k=
eys(&hba->crypto_profile);=0D=0A>=20+=0D=0A>=20+=09if=20(hba->quirks=20&=20=
UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE)=0D=0A>=20+=09=09return=20false;=0D=0A>=
=20+=0D=0A>=20=20=09return=20true;=0D=0A>=20=20=7D=0D=0A>=20=0D=0A>=20=20st=
atic=20const=20struct=20blk_crypto_ll_ops=20ufshcd_crypto_ops=20=3D=20=7B=
=0D=0A>=20=20=09.keyslot_program=09=3D=20ufshcd_crypto_keyslot_program,=0D=
=0A>=20diff=20--git=20a/include/ufs/ufshcd.h=20b/include/ufs/ufshcd.h=20ind=
ex=0D=0A>=20b354a7eee478..4b7ad23a4420=20100644=0D=0A>=20---=20a/include/uf=
s/ufshcd.h=0D=0A>=20+++=20b/include/ufs/ufshcd.h=0D=0A>=20=40=40=20-650,10=
=20+650,17=20=40=40=20enum=20ufshcd_quirks=20=7B=0D=0A>=20=20=09=20*=20nons=
tandard=20way=20and/or=20needs=20to=20override=20blk_crypto_ll_ops.=20=20If=
=0D=0A>=20=20=09=20*=20enabled,=20the=20standard=20code=20won't=20initializ=
e=20the=20blk_crypto_profile;=0D=0A>=20=20=09=20*=20ufs_hba_variant_ops::in=
it()=20must=20do=20it=20instead.=0D=0A>=20=20=09=20*/=0D=0A>=20=20=09UFSHCD=
_QUIRK_CUSTOM_CRYPTO_PROFILE=09=09=3D=201=20<<=2022,=0D=0A>=20+=0D=0A>=20+=
=09/*=0D=0A>=20+=09=20*=20This=20quirk=20needs=20to=20be=20enabled=20if=20t=
he=20host=20controller=20supports=20inline=0D=0A>=20+=09=20*=20encryption=
=20but=20does=20not=20support=20the=20CRYPTO_GENERAL_ENABLE=0D=0A>=20bit,=
=20i.e.=0D=0A>=20+=09=20*=20host=20controller=20initialization=20fails=20if=
=20that=20bit=20is=20set.=0D=0A>=20+=09=20*/=0D=0A>=20+=09UFSHCD_QUIRK_BROK=
EN_CRYPTO_ENABLE=09=09=3D=201=20<<=2023,=0D=0A>=20=20=7D;=0D=0A>=20=0D=0A>=
=20=20enum=20ufshcd_caps=20=7B=0D=0A>=20=20=09/*=20Allow=20dynamic=20clk=20=
gating=20*/=0D=0A>=20=20=09UFSHCD_CAP_CLK_GATING=09=09=09=09=3D=201=20<<=20=
0,=0D=0A>=20--=0D=0A>=202.45.2=0D=0A=0D=0A=0D=0A

