Return-Path: <linux-fscrypt+bounces-349-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 586C492CC97
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 10:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BD1D1C21A7F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 08:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5299E84A32;
	Wed, 10 Jul 2024 08:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rW2aScic"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EF082C60
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 08:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720599191; cv=none; b=LBGuh4NOkCLFi2++VZIWTYNjRwcO4wEHhKGkKmqxw4HdqF+rApybOa9MN8FGn71LmiVWKDoZ9QNAUhgxIy3CJFTZzdbJbv+aoCTLM2LaCY1aYrxPeysQezr6KWxz2KDZUJLqgR2tR1IZRaLkvkY3kr77O1V6z456nTLJlcZreHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720599191; c=relaxed/simple;
	bh=O9SgjKaUaFVh1MyqTUkFc1M8eXNYBxrFzsuS5WBTzSE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=ARF5GbxwRI2EE0u2+0wQ/p/P097kZV+U56ZaQEsnHNcsttvz2VZW4VUFQMRx0cwt6ezeI6ZAbHtj0Yaa6t566yZFlVdjVY+ZaJV0gpWmvMTWEm+SUJMTopjIA4t7NFSD6arN0qqWHafHlgPUPhvQ7Sv9yzCt7nbadrOcjwm4VbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rW2aScic; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240710081305epoutp01777032fde5dbb860807dd9c3107429f4~gy9fh7aL53141731417epoutp01N
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 08:13:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240710081305epoutp01777032fde5dbb860807dd9c3107429f4~gy9fh7aL53141731417epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720599185;
	bh=O9SgjKaUaFVh1MyqTUkFc1M8eXNYBxrFzsuS5WBTzSE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=rW2aScicbRVRO3oty4EJwWGlrLw1LBhzrs3TLAHOv5amFfl3BGNiD82bbnxkDA+dI
	 rG0iTdKfOIQQfzy9RIRCdcREAq9WjmBVMsSVXyoUYn23OnRspodRszwoTvXNfTZdU0
	 r7cVfHZuMskXNHS+H3E5qVEGaZoKJS48kHp8FSZ0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240710081305epcas5p1d84022f89d20192cc6cc64375e0c145c~gy9fJEPjg2299622996epcas5p1H;
	Wed, 10 Jul 2024 08:13:05 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WJrFq4Hy8z4x9Pv; Wed, 10 Jul
	2024 08:13:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C2.9E.07307.F824E866; Wed, 10 Jul 2024 17:13:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240710081303epcas5p3c75323ad2f13c9f43e54de9384d26757~gy9dKlt9P1396913969epcas5p3t;
	Wed, 10 Jul 2024 08:13:03 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240710081303epsmtrp2c4eaf7dff0b209e36a074b9727034258~gy9dJvtCc1271612716epsmtrp2h;
	Wed, 10 Jul 2024 08:13:03 +0000 (GMT)
X-AuditID: b6c32a44-18dff70000011c8b-10-668e428fbe29
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.92.18846.F824E866; Wed, 10 Jul 2024 17:13:03 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710081259epsmtip217137fe9cc696be34ea880088486c804~gy9ZUGKx_2075520755epsmtip2V;
	Wed, 10 Jul 2024 08:12:58 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <linux-samsung-soc@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	"'Avri Altman'" <avri.altman@wdc.com>, "'Bart	Van Assche'"
	<bvanassche@acm.org>, "'Martin K . Petersen'" <martin.petersen@oracle.com>,
	"'Peter Griffin'" <peter.griffin@linaro.org>,
	=?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'William
 McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708235330.103590-5-ebiggers@kernel.org>
Subject: RE: [PATCH v3 4/6] scsi: ufs: core: Add fill_crypto_prdt variant op
Date: Wed, 10 Jul 2024 13:42:55 +0530
Message-ID: <019001dad2a0$fc197ca0$f44c75e0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHC4eaVKc/l097EGvITZfSx67wqzAJHqrVuAgJXWaqx/S36sA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmlm6/U1+awcqPUhZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAelW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUg
	JafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE7Y/eOr6wFk3krzk04wdTAuIuni5GTQ0LAROL7
	uT6WLkYuDiGB3YwSbZ2nWSGcT4wSK97fZAOpAnOWnamD6djQ9ASqYyejxJ/e50wQRS8YJU4c
	VgKx2QR0JXYsbgNrFhHwkDjff5EdxGYW+MIk8e6FehcjBwengJVE6wl7kLCwgI/E25/9LCA2
	i4CqxNPTD8BG8gpYSsy9088KYQtKnJz5hAVijLbEsoWvmSHuUZD4+XQZK8QqJ4nGM5uYIGrE
	JV4ePcIOcqeEwBYOiVnTfkE1uEhc2XqDBcIWlnh1fAs7hC0l8fndXjYIO1vi+MVZUHaFRHfr
	R6gae4mdj26ygNzPLKApsX6XPsQuPone30+YQMISArwSHW1CENWqEs3vrkJtkpaY2N3NCmF7
	SKz/+ZJ5AqPiLCSfzULy2SwkH8xCWLaAkWUVo2RqQXFuemqyaYFhXmo5PLaT83M3MYJTrpbL
	DsYb8//pHWJk4mA8xCjBwawkwjv/RneaEG9KYmVValF+fFFpTmrxIUZTYHBPZJYSTc4HJv28
	knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYlPrOnVuuVLnrsHR5
	g+u347WaU/f+nPzBcVLYj4TOouRNLa9f59Wx7gieeIx5/r9j5qyJi+L+qUuxWp64LzX55GkH
	v+fqK9f5b01OlWVPa+E8ed226X6LcZKs7RJrY27xUKMizTtz12kcM1jPzN+7OPzso/iSTrGS
	xHOVluWFGhM8V25786h4D8NMK04jFquDzPE53xUKrV5Xz3ob1XCoqOLBOhOZEjuL03anjmQJ
	xU66InIh5Nvri0/lGZZxB7KxGqq2GMu9P1vdHXFpq//l1uspHzI/V2w4F2Kn9u/w4wPb/nht
	8VC+2dbo+9r3ntv+AHU+w9tiRYk80+8Ul16al6PhVm206r+h5aXzMwyVWIozEg21mIuKEwHZ
	EQF5QgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWy7bCSvG6/U1+aweQZbBZbXm1msXj58yqb
	xbQPP5kt1u75w2zxat43FosZ5/cxWXRf38Fmsfz4PyaLDTP+sVis+vSf0YHL4/IVb48Fm0o9
	Nq3qZPO4c20Pm8fHp7dYPD5vkvNoP9DNFMAexWWTkpqTWZZapG+XwJVx4dxjpoIVXBUv959l
	a2C8ydHFyMkhIWAisaHpCUsXIxeHkMB2RolHC34zQiSkJa5vnMAOYQtLrPz3nB2i6BmjxO/t
	h5lBEmwCuhI7FrexgdgiAl4SXa2TwCYxC/xgkvi78igjRMdORomHq84DVXFwcApYSbSesAdp
	EBbwkXj7s58FxGYRUJV4evoBE4jNK2ApMfdOPyuELShxcuYTsBpmAW2JpzefwtnLFr5mhrhO
	QeLn02WsEEc4STSe2cQEUSMu8fLoEfYJjMKzkIyahWTULCSjZiFpWcDIsopRNLWgODc9N7nA
	UK84Mbe4NC9dLzk/dxMjOO60gnYwLlv/V+8QIxMH4yFGCQ5mJRHe+Te604R4UxIrq1KL8uOL
	SnNSiw8xSnOwKInzKud0pggJpCeWpGanphakFsFkmTg4pRqY1phfvlKXp+w9cep3Nd3ULRs4
	ecRWRDFwfJmR+2BylO2UWZt/nVrFsfxIu/gkYUPX+Hr7qRKGGrMTNd9vkBLY7ePkaGo0caH4
	XtUY1gb7F5Ext7Zs3rB1y60+E68+23yZDdqhOnbrrbZeUXqd0KliddMo407sA/5+3jJOI6Fd
	Pfsvr3iv48DzNrbdqfPA220FZarqK39rZcd82r/zyXWFl3yay2Lm/HzutpRVN71s6xU9jW+d
	txNtAsx2Hn60s0NEZ/LJZReDPjz88OjNU/bANDOfqzeOLchNLK1p0lP4sUrW8n6l9wT1plvv
	rr9qWvSxoqrj5xFN3Udbb+zdduDkmlab+9FyGyKXFzy83G/GqMRSnJFoqMVcVJwIAJH4Riwq
	AwAA
X-CMS-MailID: 20240710081303epcas5p3c75323ad2f13c9f43e54de9384d26757
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708235539epcas5p319d39d1f24dfa47bfcfc373d4c748da5
References: <20240708235330.103590-1-ebiggers@kernel.org>
	<CGME20240708235539epcas5p319d39d1f24dfa47bfcfc373d4c748da5@epcas5p3.samsung.com>
	<20240708235330.103590-5-ebiggers@kernel.org>



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
=0D=0A>=20<willmcvicker=40google.com>=0D=0A>=20Subject:=20=5BPATCH=20v3=204=
/6=5D=20scsi:=20ufs:=20core:=20Add=20fill_crypto_prdt=20variant=20op=0D=0A>=
=20=0D=0A>=20From:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=0A>=20=0D=
=0A>=20Add=20a=20variant=20op=20to=20allow=20host=20drivers=20to=20initiali=
ze=20nonstandard=20crypto-related=0D=0A>=20fields=20in=20the=20PRDT.=20=20T=
his=20is=20needed=20to=20support=20inline=20encryption=20on=20the=0D=0A>=20=
=22Exynos=22=20UFS=20controller.=0D=0A>=20=0D=0A>=20Note=20that=20this=20wi=
ll=20be=20used=20together=20with=20the=20support=20for=20overriding=20the=
=20PRDT=0D=0A>=20entry=20size=20that=20was=20already=20added=20by=20commit=
=20ada1e653a5ea=20(=22scsi:=0D=0A>=20ufs:=20core:=20Allow=20UFS=20host=20dr=
ivers=20to=20override=20the=20sg=20entry=20size=22).=0D=0A>=20=0D=0A>=20Rev=
iewed-by:=20Bart=20Van=20Assche=20<bvanassche=40acm.org>=0D=0A>=20Reviewed-=
by:=20Peter=20Griffin=20<peter.griffin=40linaro.org>=0D=0A>=20Signed-off-by=
:=20Eric=20Biggers=20<ebiggers=40google.com>=0D=0A>=20---=0D=0AReviewed-by:=
=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>=0D=0A=0D=0A

