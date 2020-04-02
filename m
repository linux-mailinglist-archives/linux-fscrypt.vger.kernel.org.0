Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC3F19BA2F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Apr 2020 04:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732664AbgDBCMT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Apr 2020 22:12:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46418 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732435AbgDBCMT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Apr 2020 22:12:19 -0400
Received: by mail-pg1-f195.google.com with SMTP id k191so1093656pgc.13
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Apr 2020 19:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=T6jFhmB7PSX6gMvtk5ET86aBLDFZhVq7lni3l1FpofI=;
        b=uKfqN26wBckZlf6GLM9G9f7SHVqsK4Maj3Yc5xVDlBQg/lgN44pHfvl4KiAz4EaW8N
         Y+ItNm7Q8nQoVWm1SIPWgn9loXp6FdWMvu5lEB4rgrUkA0lItVRSWb44CZYcZdVhpR+9
         +5GNkhzimqnBF2SaqlvmIBlQOwAHbs7+PChBXZ6VMK4rTF4ayn0Kwitg8MA9wc1BpmT2
         reSUxBdqp8elIU/GyjH69iOH0OIG9MVSp1fxW/XcuAXT47Fo4fa4UV8o95NrvYpOnZOf
         9hrELfgsNIphIHFKc6RWEAqUo3GnSJ1Q2bFc8BALM2O9wRP37tBLd9RUUbuXsNKu1gaY
         u4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=T6jFhmB7PSX6gMvtk5ET86aBLDFZhVq7lni3l1FpofI=;
        b=EdcG/8rR0hPI+b41dv6zvg7rxoFvGJhQNNsR0+KUcGp5Y0Bca/gCDgbWNu8EM0Mkr8
         YCfUwKyV89QtHF7TBJpFE6d0GGSeBN52HNDVr71hpvtY2k/uplF+f8NxBCyRdMJTcPFU
         5YRvcOAgi7ncg5j6yUWcfSKKQhcTSd+KXM6dA2ZfWBTKOeeR5gkTW8h2cO4jJTAYs4Ol
         153hff/SdG5PXvDM2Kat5bb/+VY7prE3k6LpscYGwRCFMYxKbC44gP1km7QLzYuwRPBY
         L8N3w+VugtI1Xy5HxskhkSfgs4HlsZTCXo6yEAZw2/cDQHz5cC0S/TnjZunIuUXyukuG
         iIGw==
X-Gm-Message-State: AGi0PuZYtKMClh4keX9U5dHXF5w0jixqAdpK9OBduHyTI5jCc4jczoHY
        TUs7oj/O0pRzR3c55YeCuZUR9w==
X-Google-Smtp-Source: APiQypIkvQwDS7l4QdqnPD1Ys7xN/j5G7Ee6UAWFEl7CjkZVyWgASsQzrGST7DbgwMerKHZZVAdm0Q==
X-Received: by 2002:a63:3850:: with SMTP id h16mr1169192pgn.326.1585793538416;
        Wed, 01 Apr 2020 19:12:18 -0700 (PDT)
Received: from [192.168.10.160] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id y131sm2533779pfg.25.2020.04.01.19.12.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 19:12:17 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <0AB7921E-98F6-430C-87BB-63D1330885CE@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_699DAD46-6FAE-4A93-8B90-96D98631EE55";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 4/4] tune2fs.8: document the stable_inodes feature
Date:   Wed, 1 Apr 2020 20:12:14 -0600
In-Reply-To: <20200401203239.163679-5-ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
To:     Eric Biggers <ebiggers@kernel.org>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-5-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_699DAD46-6FAE-4A93-8B90-96D98631EE55
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 1, 2020, at 2:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

IMHO, it would be better if the updates to the man pages were in the =
same
patch as the patch to misc/tune2fs.c.

That said, it's better than *not* getting an update to the man page, so:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> misc/tune2fs.8.in | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index 3cf1f5ed..582d1da5 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -630,6 +630,13 @@ Limit the number of backup superblocks to save =
space on large filesystems.
> .B Tune2fs
> currently only supports setting this filesystem feature.
> .TP
> +.B stable_inodes
> +Prevent the filesystem from being shrunk or having its UUID changed, =
in order to
> +allow the use of specialized encryption settings that make use of the =
inode
> +numbers and UUID.
> +.B Tune2fs
> +currently only supports setting this filesystem feature.
> +.TP
> .B uninit_bg
> Allow the kernel to initialize bitmaps and inode tables lazily, and to
> keep a high watermark for the unused inodes in a filesystem, to reduce
> --
> 2.26.0.rc2.310.g2932bb562d-goog
>=20


Cheers, Andreas






--Apple-Mail=_699DAD46-6FAE-4A93-8B90-96D98631EE55
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl6FSf4ACgkQcqXauRfM
H+D1DRAAmD648MSTgLDc/JqmMgyUaLLfgDuaaktQajuFRp1mdQ1awh5hp+vQam6s
rfbxrlxwvyibEtnWS2NzcoeQY5kJ7Knj5xJBoVTxs0awD4mE57jiFf8Th0nRUtQT
P0pmOWnr7UaXKvHLL69C5URdZX2Ppuhbnbj202ssQPU1sIorS7ngPWbDFpTo8g1v
ZmksYgo/kxTMlG3UbNpNHEkn0G41CyKXv+y8flarYmEQSVMhNirN6bFA9BaJETcD
fHw9UCJj8A+U+6ILpnJxMRwRbvveQoVaAmSlLcJNPKxyDTmj7QdU1AMK6T/XSBVP
r2SVJBEbu4LL2qhu+J0f/kyzx4TPZLl6LKfRlHX2zoBrcGkU40lZYEohin+Y7ZP4
MACqM7LoGCo+HCP1m1kyl5rfhbf+9WP5iBI+zMgGAB/ymkuAVFw5L/JMtV4TIpg8
1dWDDdDIWUJt4nN5B2EaAzlF9DqXvVxSIsAJk1k36GnkFi2TJ1tNpwqYf8gteWFw
S+KMUTHSTQ7BBD23NevkDBV8moPiW43Urom2q5MwNtTObjsqvNkc32ibWWOygouk
utn2HV23xDZFpNrvvU9cWCKzblsv5Tuo79MEh/Y3K7bYxm1e/O6TIqQD5BMrsqlq
n4C5e4LnoM+kL12AOTbOzl5hffSM0sLGbCaAFyj6ZrDZZ4sDZPs=
=hxmQ
-----END PGP SIGNATURE-----

--Apple-Mail=_699DAD46-6FAE-4A93-8B90-96D98631EE55--
