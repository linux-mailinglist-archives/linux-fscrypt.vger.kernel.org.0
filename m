Return-Path: <linux-fscrypt+bounces-347-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D0D92CAEB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 08:22:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48AAE1C22377
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 06:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394F25B1F8;
	Wed, 10 Jul 2024 06:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XHlanHHX"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821380C15
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 06:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720592545; cv=none; b=V2AQ8UWzLutNulm+ZNJevjKQbt3MwxTbXvoZz0kYCGDByfDEysGJmQGsCaKUq8HHBLiVo9Q2GE02D5VgF0GllZiUNPPiI9YWIHzkXRe1ttEDtm3OsknnVTzswp2hQWilzC0PH4S9q5lqkPyXpgbEDEc55Sur6BFrJZoyF1KkVUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720592545; c=relaxed/simple;
	bh=vVwtCG1Wk5vw++EUY18cgyQ+iamwAosBKbNCTQvHoNE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=IdQYkRA0FA0Rbh5dYioNJD1J+2Gxa8xTeLOg0ZmKwSe84aPgdrAfkIVMlt++YeUvTlhC2MoDnWeqPVf0BIJ9RYmjGYJiy5dvBdHsfLnaVeoosNc/I5uMxtuL8kypkw5owCl/uhK2coQ9Ix1fpci+Awf14/pnYQv5haNrlMiueSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XHlanHHX; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240710062220epoutp019e56fdf7f83d9844f7e104604f689445~gxcy8aQPn1560815608epoutp01Y
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 06:22:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240710062220epoutp019e56fdf7f83d9844f7e104604f689445~gxcy8aQPn1560815608epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720592540;
	bh=vVwtCG1Wk5vw++EUY18cgyQ+iamwAosBKbNCTQvHoNE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=XHlanHHXQcrP6/Si0j2ipmX63tpNUBbAv283MGTjFFCdr1QuiNrqOD3RU1jlXJSA3
	 rYO/TF2Q/yPmn5Mus3fW4fi2hv6fpcFvIyg8j8HkfydhRoJNBWKTikCqsnKhxnv3We
	 Oa+sfDU4AQru7saQO36p+lbOG6LyJwI2nnfOGVgk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240710062220epcas5p42a9c1687f7f66623b28cf41c8312395d~gxcyT8JL11011510115epcas5p4e;
	Wed, 10 Jul 2024 06:22:20 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WJnp15cxxz4x9Q6; Wed, 10 Jul
	2024 06:22:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C6.F2.19174.9982E866; Wed, 10 Jul 2024 15:22:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240710062217epcas5p39061375551ea8f73d659d823c1dbef55~gxcvx2xv80685906859epcas5p3S;
	Wed, 10 Jul 2024 06:22:17 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240710062217epsmtrp27eba2bf6b9986ba6f57369b47a1b7b22~gxcvxEN8P1386113861epsmtrp2V;
	Wed, 10 Jul 2024 06:22:17 +0000 (GMT)
X-AuditID: b6c32a50-87fff70000004ae6-68-668e2899aa98
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	27.63.19057.9982E866; Wed, 10 Jul 2024 15:22:17 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710062215epsmtip1144ec5f39739cf3a42179766e39eb1d4~gxcuPOHQY0230202302epsmtip1W;
	Wed, 10 Jul 2024 06:22:15 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-samsung-soc@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	"'Avri Altman'" <avri.altman@wdc.com>, "'Bart	Van Assche'"
	<bvanassche@acm.org>, "'Martin K . Petersen'" <martin.petersen@oracle.com>,
	"'Peter Griffin'" <peter.griffin@linaro.org>,
	=?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'William
 McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708235330.103590-3-ebiggers@kernel.org>
Subject: RE: [PATCH v3 2/6] scsi: ufs: core: fold ufshcd_clear_keyslot()
 into its caller
Date: Wed, 10 Jul 2024 11:52:14 +0530
Message-ID: <018001dad291$82e2e650$88a8b2f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHC4eaVKc/l097EGvITZfSx67wqzAJOHFqtAZR24KyyAEqBcA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmuu5Mjb40g0m9GhZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAelW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUg
	JafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE74+esl2wF86QrJk87ytrAOFWqi5GTQ0LARGLB
	21mMXYxcHEICexgl7m39zALhfGKUeHF7JyuE841R4unMLnaYlr+NV9kgEnsZJQ7cfswEkhAS
	eMEosflBLIjNJqArsWNxGxuILSLgIXG+/yJYM7PAFyaJdy/Uuxg5ODgFrCR2tYqBhIUFoiTm
	vNsLVsIioCpxZMFLFpASXgFLiQUzbUHCvAKCEidnPmGBmKItsWzha2aIcxQkfj5dxgqxyUni
	8O5uRogacYmXR4+wg5wpIbCHQ6J93Wo2kJkSAi4S319lQvQKS7w6vgXqLSmJz+/2skHY2RLH
	L86Csiskuls/QtXYS+x8dBPsNGYBTYn1u/QhVvFJ9P5+wgQxnVeio00IolpVovndVRYIW1pi
	Ync3K4TtIdHf3sY2gVFxFpLHZiF5bBaSB2YhLFvAyLKKUSq1oDg3PTXZtMBQNy+1HB7byfm5
	mxjBKVcrYAfj6g1/9Q4xMnEwHmKU4GBWEuGdf6M7TYg3JbGyKrUoP76oNCe1+BCjKTC0JzJL
	iSbnA5N+Xkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTLoN7mGB
	WX72swob2VZ5pd+aJn9+V37ljPOVDtO8hS7zKfLY1C1rmvxqltaz6rW2ETvW5Dt/PPJ/Y7xw
	XuOjIr5jEza9czUW+P3mwrb9Ule33cs2c1bn6l7DqbC55bTkypgDrL9SPTNNT3x74mO+ZUH4
	A3c3q3MFb3bY5rCyNV1z6Dl3pPneee1ntsGTdCZMEBdj/ntS9ujx/vb55RqbnINlw8Rav3m6
	/VR2NnzD+E3hw5wtASHs5/c4RBicvRefLTf9m4JLTei1xviqo7HWvbmBidP3nG/9/WnFhh5W
	M76Z5woWJ7dcygrid516YxeLqaD/vHVReT/vrJx9YWrprXlLNl2L0drIxRj9N/WfhBJLcUai
	oRZzUXEiAFj7pJFCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnO5Mjb40g33XeS22vNrMYvHy51U2
	i2kffjJbrN3zh9ni1bxvLBYzzu9jsui+voPNYvnxf0wWG2b8Y7FY9ek/owOXx+Ur3h4LNpV6
	bFrVyeZx59oeNo+PT2+xeHzeJOfRfqCbKYA9issmJTUnsyy1SN8ugStjzaGSgqfCFad/bmZs
	YJwr0MXIySEhYCLxt/EqWxcjF4eQwG5GiS0ne5kgEtIS1zdOYIewhSVW/nsOZgsJPGOU2Lqp
	BsRmE9CV2LG4jQ3EFhHwkuhqncQCMohZ4AeTxN+VRxkhpu5klLj0+zNQFQcHp4CVxK5WMZAG
	YYEIiXMvboMNZRFQlTiy4CULSAmvgKXEgpm2IGFeAUGJkzOfsIDYzALaEk9vPoWzly18zQxx
	m4LEz6fLWCFucJI4vLubEaJGXOLl0SPsExiFZyEZNQvJqFlIRs1C0rKAkWUVo2RqQXFuem6x
	YYFRXmq5XnFibnFpXrpecn7uJkZw5Glp7WDcs+qD3iFGJg7GQ4wSHMxKIrzzb3SnCfGmJFZW
	pRblxxeV5qQWH2KU5mBREuf99ro3RUggPbEkNTs1tSC1CCbLxMEp1cBU+ybH5/2lFRfjo2/M
	b22PlqzrF9BzMU1QWDcx44u8wJMP3OdupEzsnXf3qvkip92fmB95LXcJbU841i+x7ZiQw8/3
	4S4sWQ5P+PZ0Cpx+G3ZZdsITo6jpa9Qspxvtme79p+lTuuxftZkRGSdZMmInR7ff8WxqWP77
	c2DzmnuPXXbVxDtGXj/c1c3Vdreh7E+1urDGK4n805H7JKcuuG9gp8UQdH9W9dRN5Us2Bgaf
	tGZY/2qO5utZ0gEBd05zcO40Dwt1mvI7VWffzS9Pd23rcnmdLGKkuj5GQO7Thkt7dopc/+lw
	q4FPc87GiyLqOfKGF3+sYFuyY7NN2VTJtV1GUSu+ckje0uS7en+Tg/8BJZbijERDLeai4kQA
	X2fh4CsDAAA=
X-CMS-MailID: 20240710062217epcas5p39061375551ea8f73d659d823c1dbef55
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708235538epcas5p22007c4a0ff63569c6f08d5a3f476685e
References: <20240708235330.103590-1-ebiggers@kernel.org>
	<CGME20240708235538epcas5p22007c4a0ff63569c6f08d5a3f476685e@epcas5p2.samsung.com>
	<20240708235330.103590-3-ebiggers@kernel.org>



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
=0D=0A>=20<willmcvicker=40google.com>=0D=0A>=20Subject:=20=5BPATCH=20v3=202=
/6=5D=20scsi:=20ufs:=20core:=20fold=20ufshcd_clear_keyslot()=20into=20its=
=0D=0A>=20caller=0D=0A>=20=0D=0A>=20From:=20Eric=20Biggers=20<ebiggers=40go=
ogle.com>=0D=0A>=20=0D=0A>=20Fold=20ufshcd_clear_keyslot()=20into=20its=20o=
nly=20remaining=20caller.=0D=0A>=20=0D=0A>=20Reviewed-by:=20Bart=20Van=20As=
sche=20<bvanassche=40acm.org>=0D=0A>=20Reviewed-by:=20Peter=20Griffin=20<pe=
ter.griffin=40linaro.org>=0D=0A>=20Signed-off-by:=20Eric=20Biggers=20<ebigg=
ers=40google.com>=0D=0A>=20---=0D=0AReviewed-by:=20Alim=20Akhtar=20<alim.ak=
htar=40samsung.com>=0D=0A=0D=0A>=20=20drivers/ufs/core/ufshcd-crypto.c=20=
=7C=2016=20+++++-----------=0D=0A>=20=201=20file=20changed,=205=20insertion=
s(+),=2011=20deletions(-)=0D=0A>=20=0D=0A>=20diff=20--git=20a/drivers/ufs/c=
ore/ufshcd-crypto.c=20b/drivers/ufs/core/ufshcd-=0D=0A>=20crypto.c=0D=0A>=
=20index=20debc925ae439..b4980fd91cee=20100644=0D=0A>=20---=20a/drivers/ufs=
/core/ufshcd-crypto.c=0D=0A>=20+++=20b/drivers/ufs/core/ufshcd-crypto.c=0D=
=0A>=20=40=40=20-93,31=20+93,25=20=40=40=20static=20int=20ufshcd_crypto_key=
slot_program(struct=0D=0A>=20blk_crypto_profile=20*profile,=0D=0A>=20=0D=0A=
>=20=20=09memzero_explicit(&cfg,=20sizeof(cfg));=0D=0A>=20=20=09return=20er=
r;=0D=0A>=20=20=7D=0D=0A>=20=0D=0A>=20-static=20int=20ufshcd_clear_keyslot(=
struct=20ufs_hba=20*hba,=20int=20slot)=0D=0A>=20+static=20int=20ufshcd_cryp=
to_keyslot_evict(struct=20blk_crypto_profile=20*profile,=0D=0A>=20+=09=09=
=09=09=20=20=20=20=20=20=20const=20struct=20blk_crypto_key=20*key,=0D=0A>=
=20+=09=09=09=09=20=20=20=20=20=20=20unsigned=20int=20slot)=0D=0A>=20=20=7B=
=0D=0A>=20+=09struct=20ufs_hba=20*hba=20=3D=0D=0A>=20+=09=09container_of(pr=
ofile,=20struct=20ufs_hba,=20crypto_profile);=0D=0A>=20=20=09/*=0D=0A>=20=
=20=09=20*=20Clear=20the=20crypto=20cfg=20on=20the=20device.=20Clearing=20C=
FGE=0D=0A>=20=20=09=20*=20might=20not=20be=20sufficient,=20so=20just=20clea=
r=20the=20entire=20cfg.=0D=0A>=20=20=09=20*/=0D=0A>=20=20=09union=20ufs_cry=
pto_cfg_entry=20cfg=20=3D=20=7B=7D;=0D=0A>=20=0D=0A>=20=20=09return=20ufshc=
d_program_key(hba,=20&cfg,=20slot);=20=20=7D=0D=0A>=20=0D=0A>=20-static=20i=
nt=20ufshcd_crypto_keyslot_evict(struct=20blk_crypto_profile=20*profile,=0D=
=0A>=20-=09=09=09=09=20=20=20=20=20=20=20const=20struct=20blk_crypto_key=20=
*key,=0D=0A>=20-=09=09=09=09=20=20=20=20=20=20=20unsigned=20int=20slot)=0D=
=0A>=20-=7B=0D=0A>=20-=09struct=20ufs_hba=20*hba=20=3D=0D=0A>=20-=09=09cont=
ainer_of(profile,=20struct=20ufs_hba,=20crypto_profile);=0D=0A>=20-=0D=0A>=
=20-=09return=20ufshcd_clear_keyslot(hba,=20slot);=0D=0A>=20-=7D=0D=0A>=20-=
=0D=0A>=20=20bool=20ufshcd_crypto_enable(struct=20ufs_hba=20*hba)=20=20=7B=
=0D=0A>=20=20=09if=20(=21(hba->caps=20&=20UFSHCD_CAP_CRYPTO))=0D=0A>=20=20=
=09=09return=20false;=0D=0A>=20=0D=0A>=20--=0D=0A>=202.45.2=0D=0A=0D=0A=0D=
=0A

