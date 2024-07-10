Return-Path: <linux-fscrypt+bounces-345-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6AD692CA49
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 07:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A91731C20C10
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jul 2024 05:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394ED41C92;
	Wed, 10 Jul 2024 05:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UC+1GgwV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BA541A84
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 05:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720590782; cv=none; b=lyPb1ZcxsALCDEKrmd4fhPbwKCHSZ7Wuy2I+NR0m84PFvK46VHjESlptovGDydlCrSbzNhvhdZ957ih+A0OZ0ZODx/Lq+ghDC7lUwuOwKJnPGMurpwFuy1OyfOnDEoGS9hn2p7p2zZ5DMjrG5NnW8FNI0czLobBATA7RHKHLEco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720590782; c=relaxed/simple;
	bh=8hfhVXtmivDk9qhAnKVzg4Bk9X/W2xf78uaXkISjgQ0=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=mtdVNwiw5MC15cWAlfLsxGdXiXHjLfi42nIUTsZmxBX5olBcbM73NanSjRyVG7v0VObG44ebSXLt0BSjxmhlfpIRitVUVMI4EeM/xxZPttSWLcGVyZc0TpJ7uiQdwi5c5fb6NxQEuH/f4/vHhI9VrSsf2em6AgY5Z07UH5/HHug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UC+1GgwV; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240710055257epoutp016c33d9df8f2db11f0fdf72a942ea4fdf~gxDJFZFq42088120881epoutp016
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jul 2024 05:52:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240710055257epoutp016c33d9df8f2db11f0fdf72a942ea4fdf~gxDJFZFq42088120881epoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720590777;
	bh=8hfhVXtmivDk9qhAnKVzg4Bk9X/W2xf78uaXkISjgQ0=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=UC+1GgwVGLxZheF9vcjw6dsPq+pK2UMRXTs4xRYodB89r+THeLjKeTyhglCiGi3QR
	 zsSoH09Np51RgNGU7QWOyzOOCacTPRLgbtM+eh0Sz1ZJ1NvAnxhXWP0gE2iRa39Jg3
	 FLetdch0NuY20kxlqfEjgHH1fDc4WM8OUYO6NRG8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240710055257epcas5p2ca2020f2b498e6ba02fe1b503a2ab908~gxDImwzzW0341403414epcas5p2e;
	Wed, 10 Jul 2024 05:52:57 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WJn8749Cnz4x9Q1; Wed, 10 Jul
	2024 05:52:55 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9F.C2.06857.7B12E866; Wed, 10 Jul 2024 14:52:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240710055255epcas5p4f29d8f70ff4b75534f55fc770ae9bc96~gxDGlp3s21066510665epcas5p4C;
	Wed, 10 Jul 2024 05:52:55 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240710055255epsmtrp1a6bdfae554fb911d36dcb443eac7ca5b~gxDGk7bAA2502825028epsmtrp19;
	Wed, 10 Jul 2024 05:52:55 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-70-668e21b7eeba
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.8F.19057.7B12E866; Wed, 10 Jul 2024 14:52:55 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240710055253epsmtip142a87c7b3d2c929dea3534b36e90fbc3~gxDFJRx_w1587315873epsmtip1T;
	Wed, 10 Jul 2024 05:52:53 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Eric Biggers'" <ebiggers@kernel.org>, "'Peter Griffin'"
	<peter.griffin@linaro.org>
Cc: <linux-scsi@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
	<linux-fscrypt@vger.kernel.org>, "'Avri	Altman'" <avri.altman@wdc.com>,
	"'Bart Van Assche'" <bvanassche@acm.org>, "'Martin K . Petersen'"
	<martin.petersen@oracle.com>, =?iso-8859-1?Q?'Andr=E9_Draszik'?=
	<andre.draszik@linaro.org>, "'William McVicker'" <willmcvicker@google.com>
In-Reply-To: <20240708234911.GA1730@sol.localdomain>
Subject: RE: [PATCH v2 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Date: Wed, 10 Jul 2024 11:22:52 +0530
Message-ID: <017e01dad28d$68911050$39b330f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE4iBClICFx+yLUSaJn1yRJb6SfhQJ5B3Y7AVtVE0cC5CRYggHlXsdaAlc50ciy3GCRkA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEJsWRmVeSWpSXmKPExsWy7bCmpu52xb40g+O7JCy2vNrMYvHy51U2
	i2kffjJbrN3zh9ni1bxvLBYzzu9jsui+voPNYvnxf0wWG2b8Y7FY9ek/owOXx+Ur3h4LNpV6
	bFrVyeZx59oeNo+PT2+xeHzeJOfRfqCbKYA9KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+g6JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpB
	Sk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2xsX2CawFbXoVH1qaWBoY9+p0MXJySAiYSDz8
	dpkZxBYS2M0osbSJpYuRC8j+xCix8/o3KOcbo8SZS2sZYTqeTnjCDtGxl1Fi3YNqiKIXjBIb
	135jAkmwCehK7FjcxgZiiwhEScw4f4QZpIhZ4AmTxLql21hAEpxAk15fvswKYgsLxEq8W7YI
	bAOLgKrE6qVzgQZxcPAKWEosbPUFCfMKCEqcnPkErJVZQE/ixtQpbBC2tsSyha+ZIY5TkPj5
	dBkrxN4wifYbu6DqxSVeHj3CDnKDhMAeDomN908yQTS4SKxu3s0GYQtLvDq+hR3ClpJ42d8G
	ZWdLHL84C6qmQqK79SNU3F5i56ObUAv4JHp/PwG7WUKAV6KjTQiiRFWi+d1VFghbWmJidzcr
	hO0hMf//JbYJjIqzkLw2C8lrs5C8NgvJCwsYWVYxSqYWFOempxabFhjnpZbDIzw5P3cTIzjx
	annvYHz04IPeIUYmDsZDjBIczEoivPNvdKcJ8aYkVlalFuXHF5XmpBYfYjQFhvdEZinR5Hxg
	6s8riTc0sTQwMTMzM7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoHJd1qEubv9GoPz
	P/747e64vD9xokahFPft9RqB+dr1z86ZvOg0OL9Cbel1/59sl3W+WJ5R/nzojOntaYGzRUI9
	k7Jl+VatLYgXuxdUMDnha8HsNbMCta3LXBdo/Q5aZ7rCcUF4gee+G9Fzivqqr8+9u67r8Nz5
	z9yMbuufKhdax376oxmXS4/bd2U+hgXTFt4QlHv4fWHoJFcfjwz7uxO2X3tvqLevLf9KZSeL
	BvvBSa/WLMi0Xp2dq5Uan1Fx6El3A+f5sLV5NjXNZ/8J7jpdV2HAe/6N4QOdn8Xsp9O26WSf
	Vj94f2Vl/UMXX9uaH7k2PqeMtE1eP5z84VHNc/boayrskxTWiMjIux7LPdusxFKckWioxVxU
	nAgAfOChGEUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSnO52xb40g6lHWSy2vNrMYvHy51U2
	i2kffjJbrN3zh9ni1bxvLBYzzu9jsui+voPNYvnxf0wWG2b8Y7FY9ek/owOXx+Ur3h4LNpV6
	bFrVyeZx59oeNo+PT2+xeHzeJOfRfqCbKYA9issmJTUnsyy1SN8ugSvj+nuWgt0KFbO2xjQw
	vpPsYuTkkBAwkXg64Ql7FyMXh5DAbkaJC3OmMUIkpCWub5zADmELS6z89xyq6BmjxO5fy5hA
	EmwCuhI7FrexgdgiAlESu79tACtiFnjFJNHzew1Ux3kmif47D5hBqjiB9r2+fJkVxBYWiJb4
	dHECWDeLgKrE6qVzgaZycPAKWEosbPUFCfMKCEqcnPmEBcRmFjCQuH+ogxXC1pZYtvA1M8R1
	ChI/ny5jhTgiTKL9xi6oenGJl0ePsE9gFJ6FZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYF
	Rnmp5XrFibnFpXnpesn5uZsYwbGnpbWDcc+qD3qHGJk4GA8xSnAwK4nwzr/RnSbEm5JYWZVa
	lB9fVJqTWnyIUZqDRUmc99vr3hQhgfTEktTs1NSC1CKYLBMHp1QDU+zMs/+v37n4oypyw+zP
	nNnv1+YvyH0le69Ilmfj1MSJ/p/EC/5Ienm7Rq70cO7WWbxh0VKxTLkLyY+uPfSoD9K9t3Ny
	zGLfSxMuz9jr7TAhrPtq15pQgXCe89vZbyXViaxJ4zr8o/v7zunRtyPfZslLyaZ9DDvVVpK+
	S8FUa6HGygoR+4VMZ3WsTOyOdz958/Fw18GX168qtF6v2NY/s/+pkeSxX01TxMtjnMX9a7v3
	vC9+IddwdMHfWwcOuXAfkpysYf5yWu7rDZcMbrC51/bwWHJwrj28mzvrcOGH/6+s5i7ZazNd
	bPdefq+mJknzFBGmztm3fjIcXvDaeuWaijWLaoyMz60MFGiK3uMgVazEUpyRaKjFXFScCADD
	+ZJFLAMAAA==
X-CMS-MailID: 20240710055255epcas5p4f29d8f70ff4b75534f55fc770ae9bc96
X-Msg-Generator: CA
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240708234916epcas5p1c94255e4c8c77e2929d62144e2277fc8
References: <20240702072510.248272-1-ebiggers@kernel.org>
	<20240702072510.248272-7-ebiggers@kernel.org>
	<CADrjBPoWVq-eu4Wa6_hrkk067tnZGC82UCJDyjSRGoG254w6vg@mail.gmail.com>
	<20240708202630.GA47857@sol.localdomain>
	<CGME20240708234916epcas5p1c94255e4c8c77e2929d62144e2277fc8@epcas5p1.samsung.com>
	<20240708234911.GA1730@sol.localdomain>

Hello Eric,

> -----Original Message-----
> From: Eric Biggers <ebiggers=40kernel.org>
> Sent: Tuesday, July 9, 2024 5:19 AM
> To: Peter Griffin <peter.griffin=40linaro.org>
> Cc: linux-scsi=40vger.kernel.org; linux-samsung-soc=40vger.kernel.org; li=
nux-
> fscrypt=40vger.kernel.org; Alim Akhtar <alim.akhtar=40samsung.com>; Avri
> Altman <avri.altman=40wdc.com>; Bart Van Assche <bvanassche=40acm.org>;
> Martin K . Petersen <martin.petersen=40oracle.com>; Andr=E9=20Draszik=0D=
=0A>=20<andre.draszik=40linaro.org>;=20William=20McVicker=20<willmcvicker=
=40google.com>=0D=0A>=20Subject:=20Re:=20=5BPATCH=20v2=206/6=5D=20scsi:=20u=
fs:=20exynos:=20Add=20support=20for=20Flash=0D=0AMemory=0D=0A>=20Protector=
=20(FMP)=0D=0A>=20=0D=0A>=20On=20Mon,=20Jul=2008,=202024=20at=2001:26:30PM=
=20-0700,=20Eric=20Biggers=20wrote:=0D=0A>=20>=20Hi=20Peter,=0D=0A>=20>=0D=
=0A>=20>=20On=20Thu,=20Jul=2004,=202024=20at=2002:26:05PM=20+0100,=20Peter=
=20Griffin=20wrote:=0D=0A>=20>=20>=20Do=20you=20know=20how=20these=20FMP=20=
registers=20(FMPSECURITY0=20etc)=20relate=20to=20the=0D=0A>=20>=20>=20UFSPR=
*=20registers=20set=20in=20the=20existing=20exynos_ufs_config_smu()?=20The=
=0D=0A>=20>=20>=20UFS_LINK=20spec=20talks=20about=20UFSPR(FMP),=20so=20I=20=
had=20assumed=20the=20FMP=0D=0A>=20>=20>=20support=20would=20be=20writing=
=20these=20same=20registers=20but=20via=20SMC=20call.=0D=0A>=20>=20>=0D=0A>=
=20>=20>=20I=20think=20by=20the=20looks=20of=20things=0D=0A>=20>=20>=0D=0A>=
=20>=20>=20=23define=20UFSPRSECURITY=200x010=0D=0A>=20>=20>=20=23define=20U=
FSPSBEGIN0=200x200=0D=0A>=20>=20>=20=23define=20UFSPSEND0=200x204=0D=0A>=20=
>=20>=20=23define=20UFSPSLUN0=200x208=0D=0A>=20>=20>=20=23define=20UFSPSCTR=
L0=200x20C=0D=0A>=20>=20>=0D=0A>=20>=20>=20relates=20to=20the=20following=
=20registers=20in=20gs101=20spec=0D=0A>=20>=20>=0D=0A>=20>=20>=20FMPSECURIT=
Y0=200x0010=0D=0A>=20>=20>=20FMPSBEGIN0=200x2000=0D=0A>=20>=20>=20FMPSEND0=
=200x2004=0D=0A>=20>=20>=20FMPSLUN0=200x2008=0D=0A>=20>=20>=20FMPSCTRL0=200=
x200C=0D=0A>=20>=20>=0D=0A>=20>=20>=20And=20the=20SMC=20calls=20your=20call=
ing=20set=20those=20same=20registers=20as=0D=0A>=20>=20>=20exynos_ufs_confi=
g_smu()=20function.=20Although=20it=20is=20hard=20to=20be=20certain=0D=0A>=
=20>=20>=20as=20I=20don't=20have=20access=20to=20the=20firmware=20code.=20C=
ertainly=20the=20comment=0D=0A>=20>=20>=20below=20about=20FMPSECURITY0=20im=
plies=20that=20:)=0D=0A>=20>=20>=0D=0A>=20>=20>=20With=20that=20in=20mind=
=20I=20think=20exynos_ufs_fmp_init()=20function=20in=20this=0D=0A>=20>=20>=
=20patch=20needs=20to=20be=20better=20integrated=20with=20the=0D=0A>=20>=20=
>=20EXYNOS_UFS_OPT_UFSPR_SECURE=20flag=20and=20the=20existing=0D=0A>=20>=20=
>=20exynos_ufs_config_smu()=20function=20that=20is=20currently=20just=20dis=
abling=0D=0A>=20>=20>=20decryption=20on=20platforms=20where=20it=20can=20ac=
cess=20the=20UFSPR(FMP)=20regs=20via=0D=0A>=20mmio.=0D=0A>=20>=0D=0A>=20>=
=20I=20think=20that=20is=20all=20correct.=20=20For=20some=20reason,=20on=20=
gs101=20the=20FMP=0D=0A>=20>=20registers=20are=20not=20accessible=20by=20th=
e=20=22normal=20world=22,=20and=20SMC=20calls=20need=0D=0Ato=0D=0A>=20be=20=
used=20instead.=0D=0A>=20>=20The=20sequences=20of=20SMC=20calls=20originate=
d=20from=20Samsung's=20Linux=20driver=20code=0D=0A>=20for=20FMP.=0D=0A>=20>=
=20So=20I=20know=20they=20are=20the=20magic=20incantations=20that=20are=20n=
eeded,=20but=20I=20don't=0D=0A>=20>=20have=20access=20to=20the=20source=20c=
ode=20or=20documentation=20for=20them.=20=20It=20does=0D=0A>=20>=20seem=20c=
lear=20that=20one=20of=20the=20things=20they=20must=20do=20is=20write=20the=
=20needed=0D=0Avalues=0D=0A>=20to=20the=20FMP=20registers.=0D=0A>=20>=0D=0A=
>=20>=20I'd=20hope=20that=20these=20same=20SMC=20calls=20also=20work=20on=
=20Exynos-based=20SoCs=20that=0D=0A>=20>=20do=20make=20the=20FMP=20register=
s=20accessible=20to=20the=20=22normal=20world=22,=20and=0D=0A>=20>=20theref=
ore=20they=20can=20just=20be=20used=20on=20all=20Exynos-based=20SoCs=20and=
=0D=0A>=20>=20ufs-exynos=20won't=20need=20two=20different=20code=20paths.=
=20=20But=20I=20don't=20have=20a=0D=0A>=20>=20way=20to=20confirm=20this=20m=
yself.=20=20Until=20someone=20is=20able=20to=20confirm=20this,=20I=0D=0A>=
=20>=20think=20we=20need=20to=20make=20the=20FMP=20support=20depend=20on=0D=
=0A>=20>=20EXYNOS_UFS_OPT_UFSPR_SECURE=20so=20that=20it=20doesn't=20conflic=
t=20with=0D=0A>=20>=20exynos_ufs_config_smu()=20which=20runs=20when=0D=0A>=
=20=21EXYNOS_UFS_OPT_UFSPR_SECURE.=0D=0A>=20>=0D=0A>=20=0D=0A>=20These=20sa=
me=20SMC=20calls=20can=20be=20found=20in=20the=20downstream=20source=20for=
=20other=0D=0A>=20Exynos-based=20SoCs.=20=20I=20suspect=20that=20exynos_ufs=
_config_smu()=20should=20be=0D=0A>=20removed,=20and=20exynos_ufs_fmp_init()=
=20should=20run=20regardless=20of=0D=0A>=20EXYNOS_UFS_OPT_UFSPR_SECURE.=0D=
=0A>=20It=20still=20would=20need=20to=20be=20tested,=20though,=20which=20I'=
m=20not=20able=20to=20do.=20=20(And=0D=0A>=20especially=20as=20a=20cryptogr=
aphy=20feature,=20this=20*must*=20be=20tested...)=20=20So=20for=0D=0Anow=20=
I'm=0D=0A>=20going=20to=20make=20the=20FMP=20support=20conditional=20on=0D=
=0A>=20EXYNOS_UFS_OPT_UFSPR_SECURE.=0D=0A>=20=0D=0ASMU=20controls=20the=20s=
ecurity=20access=20aspect=20of=20the=20FMP,=20one=20can=20have=20a=20usecas=
e=0D=0Awhere=20one=20wants=20to=20enable=20inline=20encryption=20using=20FM=
P=20in=20a=20non-secure=0D=0Amode/world=20after=20a=20secure=20boot=20of=20=
the=20system=0D=0Aand=20in=20another=20case,=20configure=20FMP=20in=20secur=
e=20mode/world=20during=20secure=20boot.=0D=0AI=20am=20not=20sure=20how=20i=
t=20is=20designed=20in=20gs101=20though.=0D=0ACurrently,=20exynos_ufs_confi=
g_smu()=20just=20allows=20SMU=20registers=20modification=20by=0D=0Anon-secu=
re=20world.=0D=0A=0D=0A>=20-=20Eric=0D=0A=0D=0A

