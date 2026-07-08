Return-Path: <linux-fscrypt+bounces-1755-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5gqsEBPbTWrM/AEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1755-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 07:07:31 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF61721B41
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 07:07:30 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=YPRWDNpR;
	dmarc=pass (policy=quarantine) header.from=gmx.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1755-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1755-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D21A53002D11
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2026 05:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22FC3612E3;
	Wed,  8 Jul 2026 05:07:24 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828491F03DE;
	Wed,  8 Jul 2026 05:07:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487244; cv=none; b=exgdzubHiG4I8K3vxFva8VthgY7Oqx7FlxCy8dshmtrVC67f9FCRRE77jYg/MOa7eoCDxXTgFmc9n+sfYl7/7HY0GBQgwePASfYsk2fVgpk1+oRnA15gbJRi8EgI7pVW+y5zb/3ohDp5gwnz0w6CJ2t73I9uqGFinTPOkEBBSB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487244; c=relaxed/simple;
	bh=nvt7WNqRqyVQQfU7U72gbnQ4SgmZCGKz0tvnaRd58Wk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pz+thp2ixOk6UN2RYcq0OsF9bzF5sV7/Of2/6BNsBawRwR393orzFMEken1h2XyO70TGb+s/VrUK9PNU1MJpyGYz8uHP3d0olBYR+TpICx7dQxiyWcppiqePjiyEt3cdfrcfdQ27w1OfW/JWXQ7OZLsl/izYpPuxUtbU2c4LDS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=YPRWDNpR; arc=none smtp.client-ip=212.227.17.20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783487236; x=1784092036; i=quwenruo.btrfs@gmx.com;
	bh=RZen7BYaUShi1SfRmzgT+UyjJj77IKZ8tMUPoKwqNwU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YPRWDNpRU5QuFQqgs34/TrfjAtiXSbpSUZNddDSMzSfC+H+GpuDdRLeng0yRaLVz
	 HUlG56+cie0lxwnMZyvVR6gBuaaYkltr9iVXWLuZCSbNqhJNM0IiAU3LWhxpX+iTo
	 X2/E4+Jk9hcAOK0/EAl6hIPWOBjeULzaF+jpU/Qy4Bq0fPSEEFL1658ULM6KCLV/g
	 wQHGt3k21qRwzFy1mGH5S3WVO+9Pmt+NrADSB4F0q+SxljnyVaPWhB9bbqxjy2Bfy
	 sJyWBBsSiH9MWLqubc0kjKN8HqEQxuy6j2eR/kxaon2iZ48lzC9Q+UnllA74cFzd5
	 tBDLF7GhpvbOCgOImA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1My32F-1x04c82qo3-00roO2; Wed, 08
 Jul 2026 07:07:16 +0200
Message-ID: <5077c45a-a7ae-41a8-a67f-8e4a32062644@gmx.com>
Date: Wed, 8 Jul 2026 14:37:11 +0930
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] btrfs-progs: check: update inline extent length
 checking
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260707142736.2330146-1-neelx@suse.com>
 <20260707142736.2330146-7-neelx@suse.com>
 <12ca4ad2-0b35-41ef-8527-7a047549986d@suse.com>
 <CAPjX3FfsH7tG3jy3nezrr0371EWsYx1hJEkT+b8CQF2iaMrMoQ@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <CAPjX3FfsH7tG3jy3nezrr0371EWsYx1hJEkT+b8CQF2iaMrMoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6bK7EenI8YBQveG0pieP9Dp129maDTWVV9UeQkNm1YfXtV10S6I
 L1FaCZBNOwZ45uo5UKD1a4TmJo8W2EMf2qTY1fJvW5kG2Xo7dfhGtMdSzli2FWmsWDuSyOl
 WfJywGbxRI8DS9SI68dyMvBVmx/dFVB6b2RI53xg2bvlG48WfzM5HY6KA2n0A5DT3A0DtM0
 T0vbHvmDvikpybOG5ecnw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Qa0wFD89LDE=;DFDFlLVKzi3bUHvKEOvseiLeGVG
 ls5b+o5R1KTJ1GUfq7TsLU/nQugDZoW9qKn5vIv0+EdjKCGpH7sJ/TM/y08IxneszjRToeEwM
 iY9+DTAGgst0R5/RMX0KlLk1mZx2s85o7XpCpsG0/FBB2LSxvklfHv8PPVwB5rWjxhUrJ8gMx
 W2uHVMlQBNqzUd4UQYJvJ4pfY3nQoVIOhboftRc8/RcEDMmo9SYJrYdubh8bLgMiGut18jZ89
 MttNv9xXweJhOWK3psOWGbQkgcWphqPM/7neYtdVYWh2kbMz0bRDQRrBxvYQsuiLK97/FTT6/
 SEB3i01QdrlS2lgaOYhpQFixkI9q+t/kWeCCxZlQhCXya0/jZLxG3ZGjKmpMM+Bobll6aE4Be
 oCFWZ6yw71jPXIFLLfgfMYlYlQIm918Pfx7PvmFRmfn/Y3vVzFp0R0p3dv5xtsYGi8Qv91Fip
 idkeEGuDB4VwuHNFJ6f4IdpgkoBs4+yzJEA0+AQfoKGwd1q6rf/FaFsiOW9vRMKAxBeAMFyrH
 icwuDJppFDdQDpDbhe9W4w1zFbHsXMgDGLxB6Lh69Tfmvcn5eYz9jTm+ZH9SfEC7yTVFqqQVk
 Ih2rkFbEP7pS1IVqx/h+dJ1Qk7o+VdWPB2e0lAZFjOhN3t65xFyh3HEzVpmZt8zCWLGfZ8zcz
 1EgLgmFsxoXAxwZ+UcA+Mj5P8oQZh52i3f7hC21YmPUuvd3BuHvKDw1ALYmwjPlKFjiXihjk9
 9jz1cPz9Y+RWcpscigiiYAnNgSlB1ANnS99nKh/xB3oGYBzd1nwT/Jq+ChBEKUx4nu701jDSv
 G40nxBAijtPWWHyVHovrefalCEYAY1E3sIE0aM+5eggFkevJK/xhOuHmipH7E4mqilvJ4gNA5
 KhezYlMY7b7A32cUZfGgrmr1eCmbrBO4ciD/BvqJRs3Jt/2uZC5YpEYm56uif4uYs4MQk1GlL
 yIOMrQi9/6JQpcx2zOZwma/9SP6amdAfQYRDpv0ajamJ1SNBADDKb46+s2nCAJQp31qra4/b4
 x2LqShL8wjAYDwai6C/h8h7xKJa2BR93eS1dmUJACgaJeTx7arXx8p7u159NMbFK7kk9vsKoy
 ZwUc19dMqY7KPigQfmmiVlNMWdJ+QCsYpwynnZHc0MwLxLedCqxjx0VyQTb5woUiOpUIwTuQ9
 VsQSj5ZLlo2QslcDUNei2qSlTXtuGT19VkcmaCrq7PX/K4wWwB466QpRVSkZWm0LzOjBOL23x
 NBoU24qbERvMdlJqRhSXjYHOSI7/pnZUyF+VJjMTiMKH3Dc8H7LA0UMkeJ6aPKoHzYmj14qx/
 h++DTm3jYa77Z1sYaxOypvvBfuPQ7UyKlzTgvVgPmP97AvgCTI16pdKKPMsB27sTa8JrtIyOd
 fY1niqtCsbn5RZT5NTR7Y2wWTCCttMWRk+guJis/zJUfKtSjPH7EO6KPFaBOxR4giNF1R4RRU
 s2JFIF3+z0GOAhBxObglGd/YGnubivZYDtaoxEaOa2m80YMzucBAU4L1n01jP2+PKJGjUEOWr
 gkgW7lFT/918XeHa0+Xq6xQ9zGlpue0Y3jUWXYcLhuxtlNoMmFf2AqY68ZIjrkRITmSIkV2kp
 i/uktlPD3t/9hS5r7UH72NmxBx9qnCA6MUL+rW326zD7UGPwg4HFAdlV6TX6JwlACtuQXo7Mk
 BLwukQzZgJpDPXqskk2M2IfwEYUV1aEppOrZ1Q51OFt5XYgpVyBqIpwQlD4lkDhuaNuqzuNiP
 pd1eTjaMJOGxXLAkUoexxV3jhOz6nb23ZKPApi7NIBi/8sB7BLbHU7v7jx9yd98Gs5kyT39W1
 eY7K1BocidbKXptkgSbI6kboofsRN9rO8H0RJGtxIdX4DrNxC+uxUESbN2keosCaqqoZJ1sZV
 R6Xkp5s7e6ylI6ZD4io6x1iy5ekWT+k+9aCdWwzvLYGmSpztkEkQjqAGqcunAXpMgr3qcajgW
 LfWQzEoFQ2E5oapQsZO/aDke1jk1dARVOkUnBh2XcV/ZYStlupnE8ZcFa8RuT1tXCeMbj8Pk9
 4T510TRioOcYHGRfm+aU7QmWysRQD+sA+USgrB2bgx8FtJrJBKn3LyRH5aV7Awqs+qOLLPXfK
 2VpGiLirImir8SUG34sXFtF0FsUOt+D6rISFExJ4Bbm9lJC/KWo2FiRhWAWPF96UO6iQr1u0+
 x9IkV7rQLnk56zISQHMJjPiRD2+7OswmlGoYM5y8rUThOi2ACfiYUShaw7gAvQYZCm5kyrXnB
 QgAVNsxIdG4tLMM8NRSDfkkWuFQbvr53IWztEcpKX6ypSMuRm4RZzD3jbjRceerh28Luna6Bq
 7eLlgAPJtECwqgGmMjsgnXFyGRS3CeoV9PA/Pggu/EAwFseiXheJVZOS9eNErIXsEN+OsPQ3i
 2YdfTngO1+8qVscFwTywr3jcAdboDk1AYO5oslwgdqpy9zEB5Er6ha40Wgla2O8xElJpLVPQq
 i+wKLVy3DgYm74ybucwHRcyZ4m2cnS+XAbwNcz+jnYZ/g0mqLHKzVuyznzzGWzrC/6fp21BT9
 GDT6Xqc0yfeNoaTRxupIzcpeLu8pACeg1GabZlcOj1bk4xrnKOe8YdjJ81GADUz5c/DznhSHE
 zcPkuhhGSUSrFsj9WN7dt3SgXROJvI8hhNaKYiqmaaoWx8gFMeuRl9r+BqWA7/Dxrr0YO/5Ja
 yOZnK+Jqb3e9v8QN75TDgHJY6vWnGRAJ7A9bgX3ktQlTdHOjS1YMIAUd06nShsrWHXDO2xHXz
 XE6cCm+fpQUvGHXNIXxivTDfArMmOs3wmaMsM/P48eqH81IoigYPoEnkSkYL06E1woQ97+RJR
 twsJMRtUCwlpZmpsxB43uXt9sl2MoE3JwJmUKGLiSPowVuXjMBAuIA/xeBa8s7IjYQbLmeWZN
 EVNdw4CBuUYWuCV9XiIS10MlXVfdXydOb9oIxdg8BTdKLtk3kClCqi4S3F9h8k+Zj0AulEci+
 PPOrlzNMEhiG4RD9ZpsI9b+x2yoTTWzxz0Znp123uQdBdX6mXB2Beu9e+EU3j9oXK7oV+WpsQ
 zmXiipHARID1oz9sGqYNoWxj4e6DNMEaHbRfjjfSiC8Vhqyncvj47fKKg2HqP5PouQhWnYxRu
 GO1KDvPuasr1WTtcyq/o38ChhTHAIFjmZS4E4Zvp+LfuqU9qeDmrz8UNZ9mBQX1nV3emZ+DZY
 X1j3IkbA4vgO/9OlmADSaGcLzv1tf+2tD0EmTXSoH2kXkXwCwPOmWZo6t2pVGKsZCkRhJnwoj
 z8pqsgvPVb5+dlhUM0uXFEEY1eNqRPB8HtcHi2vzc2KBmayPPfZHkJaT20JG0/beuiDxfIPoz
 Z38V0pQ4tEaydf6Ls6g93RYxFyVuoBKRV0sfbBwqugb7olw1hgUAzHWLZt6dj5H2wcfpH4lOk
 DWvcn3iuHlW3iI5Q4uEc0dMa4fW9g8gWvO7Q3hYTU7hmDWK6xGMMntcJUjY+9bYy/fqcNigeb
 mQRerFE8rMQhd3vAqenaYAC6pYeBSrG5yDO79XByQ5RNLdXo6kdTRg8hUvlrdv46cBZO28r7j
 UQQRt+nBwk4ymn603j0ou9n2UdZEI28KDIrvnnSlhSw7PanAtcC6TFf6twb8rfFHxkFq64RfG
 MAz2VDdAbb5szc6URmqF9F1W6aUASsOXlF8ZgYwpjPmbyYfnbFLy+uPzkPEBt3rrH1mjBkw/2
 wgLGfoW2a1ZTbh+1d/xACYkc6qQmj118g37sg9+5pHHoX0Aq6edMCYn438A36YXM6arXTge13
 J2llibyKLXFzEAMac91sdZRdnxWQ2SCJ7/oljipOEwz9iOKZqELOh0f5pc/j+e11gHvcEcdMI
 R3Gn7VtHAK/S8YIsdtbGSl8MikpKyvwPBEBX2ekJrtECVVoxBTUPw2RuXCuaYHOXRI0fUZAsz
 /BnY0A2UsvKF2nwmWkdTNCwe1xZVeSeiAp3tkbUKQkWZM1u7eQ0tGN0UtIOnna8HI1Y1plp9k
 CLWV9fwg7TrIBTWYzn0JNedXn8qkHlgOPR03QewFjL6VaLDwl+vQmKTwjJgHdJGX49Mq4Bu5N
 baJqowXTl0NXdUVWeAhPE74PFajequ0U+9LbAE4GD1O9KDVKSQ0nZki0rkBXDerGeiSaCHcje
 +Eni8FpHlWqMemnhbu2jQRWhrfuwKkxIx3alkK0weIrKRAxfigJNoPDq8EAAq+XUMkyuGLWmH
 aHyK/qNfMXEhDKHYqohOY0XZMV2vrQQ+wxcJt3YoXpmdTDqTJRuxhM781r9W5wo+lAgZjkTO4
 26JbElaJ+OfgyMRbmsJl7ah6GapehsC4rRCTi2Q9SJwoOi5SvRIJ7f03cXuHdfyX7YJBY1mwW
 fUTao8eDmDmS5xv+GRHhpyLX51PHeckiob3vkw3QlyD3Y3i7QzZb0cye9Wr1dbRxFzASI5cUR
 IBtfOEiCE3+XKh8iV8U0Crn618HEDTnZKZpwhV2ZetrpFHMxsRhz3Mfzxd5GvSpaUBO3vhGDB
 3neUarD+3FjKW2AuenXI6lpSaAFBW5jzU7ViVBjLX/id4cLDkK66ij/9FYker/4o+R/weR0Ji
 iSEHd6tnJ7KUeWPhmzGtcF/GBANwGTr37VRe12LfFl3gj+IsbYCjCxz7Z0AS/yRRAnobHLDUJ
 tyDevhI242jBflBEGie/wmkX6B2nFo7BilqT1Zb3gXz5rp1nUqaYh9gJhxmTW+fKbF3c3TWCE
 ZWzH+KR8QaLQvatA/vFvqNkycL1TJTMXBgmzDVqk6RDRE94P3Uzu8jXv3HtQbIPvQ3fPys26b
 KIAHKr2QcoDyzdP18g5bnXGeaw5kUNGSVoHp1GM/GBHp8DaCfrJ2ur7QCROPINTk17xmd7EDN
 0Nvgywzq2WAIXEaY39GPUkSbGk86JlMrkYbUcFxkgLrpgQ1L35sB8thTcdebDHGm6DexzgT1K
 yMrd2B+18ng17zIyhpePdXB3BxTXG2zp7ywiTyhWP4wGarW4nUs/Fs8s4SfTTCK3a89zlYPsf
 Lvzx5RTNwfqKJt1p9wbq3x7xaa8hsV6+Ma2Ss81SXOfEG8tfvqtird60pdth9eAckucO6cDg6
 OZ8dIThTncr1X4iddZ4+fW2lZHqz1e9hDvWnBZsWVlxs/hzXu8L95E4jVQtBhURbuGFfPPC5f
 vLWA5mBqTEGbnsLzr8UT0tFb2qckjYdhnpaaatn5tF0zRR3sGuvv/Jq2IJ9u9x2Qarjfc0Oue
 CLf3wIxdf4kt8+x6Ca/SmhXEFpmxE3sonOS2uExHRZDXFE4DRirMegHTSpI2Kmplb44N9l1HB
 rADLrbuWWVdL+OtMwWz1zuy9wjxfwPSEgjQbYznRnSgYgR3KmgtNTRmZjrEZ6uPABylmjkMkV
 N140QZEtLBSrpNdBImO9+et5eiOyR6cbOAeAbSVHSqCYMpQg1BkZ5SVE9aiqBBJmMr4RWhL2g
 4CVpfAP4TGipPSRs/7vrRI0TfWoBRiSTJGSKKobu0IgaeYtlnctgINX7Bk8hXbeCfliwPedxw
 bu9PdZ6/binQ4DRPn1a3OmkEoO7tzjvc87TeMu7NASG5ZH3biwgT0hzcZqIM8g5+7Jeg+4PLK
 0LO+rl2syTWn/3ol4GJwFrpsIy+aeOI/Mzjbvv3OE0dqjTonsiSD5UfHPuBN3QAel6Scpw==
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmx.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmx.com:s=s31663417];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-1755-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[quwenruo.btrfs@gmx.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[gmx.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmx.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[quwenruo.btrfs@gmx.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dorminy.me:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:email,vger.kernel.org:from_smtp,gmx.com:from_mime,gmx.com:dkim,gmx.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3DF61721B41



=E5=9C=A8 2026/7/8 14:30, Daniel Vacek =E5=86=99=E9=81=93:
> On Wed, 8 Jul 2026 at 00:43, Qu Wenruo <wqu@suse.com> wrote:
>> =E5=9C=A8 2026/7/7 23:57, Daniel Vacek =E5=86=99=E9=81=93:
>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>
>>> As part of the encryption changes, encrypted inline file extents recor=
d
>>> their actual data length in ram_bytes, like compressed inline file
>>> extents, while the item's length records the actual size. As such,
>>> encrypted inline extents must be treated like compressed ones for
>>> inode length consistency checking.
>>>
>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>>> ---
>>>    check/main.c | 31 +++++++++++++++++--------------
>>>    1 file changed, 17 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/check/main.c b/check/main.c
>>> index 9447b01e..cadcfef0 100644
>>> --- a/check/main.c
>>> +++ b/check/main.c
>>> @@ -1720,9 +1720,7 @@ static int process_file_extent(struct btrfs_root=
 *root,
>>>        u64 disk_bytenr =3D 0;
>>>        u64 extent_offset =3D 0;
>>>        u64 mask =3D gfs_info->sectorsize - 1;
>>> -     u32 max_inline_size =3D min_t(u32, mask,
>>> -                             BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
>>> -     u8 compression;
>>> +     u8 compression, encryption;
>>>        int extent_type;
>>>        int ret;
>>>
>>> @@ -1747,25 +1745,30 @@ static int process_file_extent(struct btrfs_ro=
ot *root,
>>>        fi =3D btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>>>        extent_type =3D btrfs_file_extent_type(eb, fi);
>>>        compression =3D btrfs_file_extent_compression(eb, fi);
>>> +     encryption  =3D btrfs_file_extent_encryption(eb, fi);
>>>
>>>        if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
>>> -             num_bytes =3D btrfs_file_extent_ram_bytes(eb, fi);
>>> -             if (num_bytes =3D=3D 0)
>>> +             u32 max_inline_size =3D min_t(u32, mask,
>>> +                                     BTRFS_MAX_INLINE_DATA_SIZE(gfs_i=
nfo));
>>> +             u64 num_disk_bytes =3D btrfs_file_extent_inline_item_len=
(eb, slot);
>>> +             u64 num_decoded_bytes =3D btrfs_file_extent_ram_bytes(eb=
, fi);
>>> +             if (num_decoded_bytes =3D=3D 0)
>>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
>>> -             if (compression) {
>>> -                     if (btrfs_file_extent_inline_item_len(eb, slot) =
>
>>> -                         max_inline_size ||
>>> -                         num_bytes > gfs_info->sectorsize)
>>> +             if (compression || encryption) {
>>> +                     if (encryption)
>>> +                             max_inline_size =3D min_t(u32, gfs_info-=
>sectorsize,
>>> +                                     BTRFS_MAX_INLINE_DATA_SIZE(gfs_i=
nfo));
>>
>> The change looks good to me now.
>>
>> However I'm just curious, is it possible to limit the encrypted data
>> size to sectorsize-1?
>>
>> Or it is some fscrypt limit internal requiring a power-of-2 size or jus=
t
>> lack of interface?
>=20
> The encrypted data has the granularity of the cipher block size. With
> AES, it's 16 bytes. Hence why.
> Eventually the best we could do would be sectorsize-16. But then, if
> the cipher changed in the future...

Thanks a lot, that explains the reason why we can not follow the old=20
sectorsize - 1 limit.

Thanks,
Qu

>=20
> --nX
>=20
>> Anyway I won't object this new change.
>>
>> Thanks,
>> Qu
>>
>>> +                     if (num_disk_bytes > max_inline_size ||
>>> +                         num_decoded_bytes > gfs_info->sectorsize)
>>>                                rec->errors |=3D I_ERR_FILE_EXTENT_TOO_=
LARGE;
>>>                } else {
>>> -                     if (num_bytes > max_inline_size)
>>> +                     if (num_decoded_bytes > max_inline_size)
>>>                                rec->errors |=3D I_ERR_FILE_EXTENT_TOO_=
LARGE;
>>> -                     if (btrfs_file_extent_inline_item_len(eb, slot) =
!=3D
>>> -                         num_bytes)
>>> +                     if (num_disk_bytes !=3D num_decoded_bytes)
>>>                                rec->errors |=3D I_ERR_INLINE_RAM_BYTES=
_WRONG;
>>>                }
>>> -             rec->found_size +=3D num_bytes;
>>> -             num_bytes =3D (num_bytes + mask) & ~mask;
>>> +             rec->found_size +=3D num_decoded_bytes;
>>> +             num_bytes =3D (num_decoded_bytes + mask) & ~mask;
>>>        } else if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG ||
>>>                   extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
>>>                num_bytes =3D btrfs_file_extent_num_bytes(eb, fi);
>>
>=20


