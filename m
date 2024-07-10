Return-Path: <linux-fscrypt+bounces-350-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF2692CCB1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 10:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D4DB281494
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 08:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E2D42B9DD;
	Wed, 10 Jul 2024 08:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RzBP5cjN"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A8C1272A7
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 08:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720599428; cv=none; b=BPgzbd5VhS7Vgrcd18QbTdbhqtDZ9bZ7hFxkaL4OpUfsbkPrqz/LAjdippxdGDNssWxusvUK7q7X3u65ezgZaJxSsO+F1yDudX/xC0BEB+/5AP7OcLVnQnP5l3H+SNM1weAxsjwOv1fs4ro1u/jEp1KFEeTgUFmyJEla80jhay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720599428; c=relaxed/simple;
	bh=SyZbdH4XHMVOyn0+gjmc18I82uWoWT8U6ThJck9QQrA=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=Y37brw7FEKO5l/YAej784Peo88ehTnrUEgRb/peYpMc4vojyVtdJDKzMtAhDXxaNSdp2Cp15jCnAVwAYQcN3LvLIaZsSXvN/T0IQT40me5ToI1Y/vs1+t7cis3UUMPp+E5gbcEUZ3roRyjVoK5DWSxHvfu9RGK/4G1OhcXu4wh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RzBP5cjN; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240710081704epoutp04e7d4551cdda5ca20d057e525a730fef0~gzA9unwIM1166011660epoutp04b
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 08:17:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240710081704epoutp04e7d4551cdda5ca20d057e525a730fef0~gzA9unwIM1166011660epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720599424;
	bh=SyZbdH4XHMVOyn0+gjmc18I82uWoWT8U6ThJck9QQrA=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=RzBP5cjNXzhSMzC4YpQqo/PEGxKQYWf8+a2V2ZDsmN/Wzolx3nZs3CL4pOWb3O5NJ
	 D86pzw+0DxRorW3ZeqsY4FUxhfjZNDVkQ4XMOvkMOOzqFBzBThzKyAqqs9yW3h+XZo
	 398P5OxL3SO8kf21Zcc8NHEcJ+BN1EpOTLSEWSAE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240710081703epcas5p2a4b3e7f9c4679fe6278ce5e9c3e00cb4~gzA9PKEat0107901079epcas5p2r;
	Wed, 10 Jul 2024 08:17:03 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WJrLP74xwz4x9QD; Wed, 10 Jul
	2024 08:17:01 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.2F.07307.D734E866; Wed, 10 Jul 2024 17:17:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240710081701epcas5p208480cd0e292eb9710d3bdb74b97b591~gzA7GcBZR0120001200epcas5p2m;
	Wed, 10 Jul 2024 08:17:01 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240710081701epsmtrp28d851816ae2a260f136c730d3ec10f33~gzA7AXgVN1478214782epsmtrp24;
	Wed, 10 Jul 2024 08:17:01 +0000 (GMT)
X-AuditID: b6c32a44-3f1fa70000011c8b-76-668e437d1b48
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E1.13.18846.D734E866; Wed, 10 Jul 2024 17:17:01 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710081659epsmtip1a27412a6b755e24cfc01faac3af512b2~gzA5c-QHl0579605796epsmtip1Y;
	Wed, 10 Jul 2024 08:16:59 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-samsung-soc@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	"'Avri Altman'" <avri.altman@wdc.com>, "'Bart	Van Assche'"
	<bvanassche@acm.org>, "'Martin K . Petersen'" <martin.petersen@oracle.com>,
	"'Peter Griffin'" <peter.griffin@linaro.org>,
	=?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'William
 McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708235330.103590-6-ebiggers@kernel.org>
Subject: RE: [PATCH v3 5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
Date: Wed, 10 Jul 2024 13:46:58 +0530
Message-ID: <019101dad2a1$8a194350$9e4bc9f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHC4eaVKc/l097EGvITZfSx67wqzAJvBtw/AOMLTLyyBO6KgA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmpm6tc1+awaETlhZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAelW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUg
	JafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7Y/W6iILNvBUHl89nb2C8wdPFyMkhIWAiMWnH
	HMYuRi4OIYHdjBKPtt9hAUkICXxilLjRogFnT261hmnoar/EDhHfySixYDkHRPMLRolVbU/B
	EmwCuhI7FrexgdgiAh4S5/svgsWZBb4wSbx7od7FyMHBKWAl0blICSQsLOAlcfngTkYQm0VA
	VeLmzxPMIDavgKXEpjWz2CBsQYmTM5+wQIzRlli28DUzxD0KEj+fLmMFGSki4CTx7p8GRIm4
	xMujR9ghSrZwSFw86QhSIiHgIrFmRTFEWFji1fEtUCVSEp/f7WWDsLMljl+cBWVXSHS3foSq
	sZfY+egmC8gYZgFNifW79CE28Un0/n7CBDGdV6KjTQiiWlWi+d1VFghbWmJidzcrhO0h0Tjx
	PdsERsVZSN6aheStWUjun4WwbAEjyypGydSC4tz01GTTAsO81HJ4RCfn525iBCdaLZcdjDfm
	/9M7xMjEwXiIUYKDWUmEd/6N7jQh3pTEyqrUovz4otKc1OJDjKbAsJ7ILCWanA9M9Xkl8YYm
	lgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTDtubpgTUp9To/Os4Lc9TeS
	NlgnlcrrsPB94Ir8fbnRgvn5NPeTwflrtvQpf7rSnO2iNGnH7YVPHCZeUap6d0ug64fNJH9p
	nZVbbTo/nbmSJBAac1ZIICX05gwWceYJDg+FmfNZooL1xXp3XIiP8ZI9vYnnfcO3cv4UKa0n
	IiH/pzSFfzlS9veIAPv9kGNBy1bGllhsOKSYtnfd2UnGL3hz3pSL3N/wt7msJPzh7QDRi6x8
	3Ot4J6ddcUwVdvYz2HLlT0j2Su5DBhvkkxcuKmp47iqw2/3CsnN3Fz7m0Co5ayd+f3vN/N0B
	/S/c44MzfxzbZmu/f8kvrR/N64U2VCR2MfdcXsnXo51g8mwCh6ISS3FGoqEWc1FxIgCCf9B/
	PQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSnG6tc1+awZ4PghZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAexWWTkpqTWZZapG+XwJUxo7eHreAYV8W3Ez3s
	DYzfOboYOTkkBEwkutovsXcxcnEICWxnlPg1fTcTREJa4vrGCewQtrDEyn/PoYqeMUo8P3qY
	GSTBJqArsWNxGxuILSLgJdHVOokFpIhZ4AeTxN+VRxkhOnYySry9M5W1i5GDg1PASqJzkRJI
	gzBQw+WDOxlBbBYBVYmbP0+ADeUVsJTYtGYWG4QtKHFy5hMWEJtZQFvi6c2ncPayha+ZIa5T
	kPj5dBnYeBEBJ4l3/zQgSsQlXh49wj6BUXgWkkmzkEyahWTSLCQtCxhZVjGKphYU56bnJhcY
	6hUn5haX5qXrJefnbmIER51W0A7GZev/6h1iZOJgPMQowcGsJMI7/0Z3mhBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwenVAOTYhrvjF7hqS0zbzA5+65mvdd0
	TjGeq3DzFkv1LTOyOi/596Rtkpx8nIHtq8KZ7IWqRkEyCcoNG0x67vU7JmTxhB2u+r+jTE7f
	bt3mG2927zVrP+BSkXqNbecM1h0TmE/aHm2eGCF/n/vCq99135/az6hZ+Dp9aUTm2h27L219
	yD4x3+rQG+7tIsvtHmlYWXyY0jd30q+Xp1IPx2rLXP960Gyj6iWd2NcZspvDJETCJ3w+eWit
	1Z/cDyreWi9/bdYtqtvgknCkOXDiXbNt2nztJ9dYrXj26IV1JvvLZdde37QzlhXiuKC9/X1R
	qrTSJJmdc1om/TgTz37+4Dpd96Nv/1799nHnIx5RTi8ub2FdcSWW4oxEQy3mouJEAHMaiHMp
	AwAA
X-CMS-MailID: 20240710081701epcas5p208480cd0e292eb9710d3bdb74b97b591
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708235541epcas5p2b85e24471f5896d4c586707bd1f015e2
References: <20240708235330.103590-1-ebiggers@kernel.org>
	<CGME20240708235541epcas5p2b85e24471f5896d4c586707bd1f015e2@epcas5p2.samsung.com>
	<20240708235330.103590-6-ebiggers@kernel.org>



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
=0D=0A>=20<willmcvicker=40google.com>=0D=0A>=20Subject:=20=5BPATCH=20v3=205=
/6=5D=20scsi:=20ufs:=20core:=20Add=20UFSHCD_QUIRK_KEYS_IN_PRDT=0D=0A>=20=0D=
=0A>=20From:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=0A>=20=0D=0A>=20=
Since=20the=20nonstandard=20inline=20encryption=20support=20on=20Exynos=20S=
oCs=20requires=0D=0A>=20that=20raw=20cryptographic=20keys=20be=20copied=20i=
nto=20the=20PRDT,=20it=20is=20desirable=20to=20zeroize=0D=0A>=20those=20key=
s=20after=20each=20request=20to=20keep=20them=20from=20being=20left=20in=20=
memory.=0D=0A>=20Therefore,=20add=20a=20quirk=20bit=20that=20enables=20the=
=20zeroization.=0D=0A>=20=0D=0A>=20We=20could=20instead=20do=20the=20zeroiz=
ation=20unconditionally.=20=20However,=20using=20a=20quirk=0D=0A>=20bit=20a=
voids=20adding=20the=20zeroization=20overhead=20to=20standard=20devices.=0D=
=0A>=20=0D=0A>=20Reviewed-by:=20Bart=20Van=20Assche=20<bvanassche=40acm.org=
>=0D=0A>=20Reviewed-by:=20Peter=20Griffin=20<peter.griffin=40linaro.org>=0D=
=0A>=20Signed-off-by:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=0A>=20-=
--=0D=0AReviewed-by:=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>=0D=0A=0D=
=0A=0D=0A

