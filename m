Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AEA19BA3D
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Apr 2020 04:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732435AbgDBCTn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Apr 2020 22:19:43 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33386 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732498AbgDBCTn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Apr 2020 22:19:43 -0400
Received: by mail-pj1-f67.google.com with SMTP id jz1so2811797pjb.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Apr 2020 19:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=cRVGT7W3LSRRhDk/rlNVm/PGeYNXtUFpf2OpNSP8aCM=;
        b=DqlOzrYRWebqHdkkoa2qFY3+eudf2pM6EUhuM1CofZ9vXs32ZXpsmkysBD9K7ebG9P
         2bs+5Fbm+n4irVdwPYDmv7Iashc7AabNVnLn8jqXdYilnfi+wyhskwbvYoy2cZwq44Xz
         iptdPKK8LwsVIPJahctTYWBLu3IeT+LrtPYoxoTGlbcw5RBwqLvKpqpDGrtcXeGI9jrF
         o9REK3cZB56kkER8wXJ7VZ38uFG0EblqiTRj4q6CQ55WPWIzp3gc2KeMaHcrOAJqAWin
         E93iINt3+sFzneWuRBDd7i+CwbRQ+ytR5c2aKx7FRQ2QmWfUDlYbwcFBX4MwFkag++lr
         FS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=cRVGT7W3LSRRhDk/rlNVm/PGeYNXtUFpf2OpNSP8aCM=;
        b=R4boqW69f0O72Lwy3/wuUY3/jXyMOFUUicnvka2+bB4zrWNUMZmhPyECPhOkzEDDXL
         ujfOm35r5wnMnb8sCFCgfFJiP0F/Pp3j0r499LqJYLJJ6MzSNXcu10mj5cjHgNz6yEs6
         Jefva4j8U+dgFW5S986pZmrSHjsJ6OEOzc4+yMMlje4i/bVBsuN5Po3g1RSfml27dlJr
         qKc9A8YRRzxR/u7BKcbiA22TfOkul+DhMQorogwLFr7X9KxBMjbWw71N0FpLTW/0MTX3
         mWkHKPa66w4HIgakhV3ZqWcjm+3QrxiKVdwBUogTVSyVWE5UQHL1PoY/JSZSTQI4OHdz
         4Bww==
X-Gm-Message-State: AGi0PubcWl2F6AfI7/vlbDCboeasePQQZY1U4DtJI5c6E+Bg6hQE/uAJ
        JT6cEtHxEnqFS4n8Zi1wpjuHaxRI6SM=
X-Google-Smtp-Source: APiQypLpXkU5bSVRh2yjAef1xnXw6e4GTt7bV6enrqrtV7qe+m16wK+MIVa8o35unsuITXyBEt17Dg==
X-Received: by 2002:a17:902:207:: with SMTP id 7mr823113plc.216.1585793981023;
        Wed, 01 Apr 2020 19:19:41 -0700 (PDT)
Received: from [192.168.10.160] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id b189sm2543041pfa.209.2020.04.01.19.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 19:19:40 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3DA047BA-35EF-48C4-A8AB-ACB70041D364";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 1/4] tune2fs: prevent changing UUID of fs with
 stable_inodes feature
Date:   Wed, 1 Apr 2020 20:19:38 -0600
In-Reply-To: <20200401203239.163679-2-ebiggers@kernel.org>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
To:     Eric Biggers <ebiggers@kernel.org>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-2-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_3DA047BA-35EF-48C4-A8AB-ACB70041D364
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 1, 2020, at 2:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> The stable_inodes feature is intended to indicate that it's safe to =
use
> IV_INO_LBLK_64 encryption policies, where the encryption depends on =
the
> inode numbers and thus filesystem shrinking is not allowed.  However
> since inode numbers are not unique across filesystems, the encryption
> also depends on the filesystem UUID, and I missed that there is a
> supported way to change the filesystem UUID (tune2fs -U).
>=20
> So, make 'tune2fs -U' report an error if stable_inodes is set.
>=20
> We could add a separate stable_uuid feature flag, but it seems =
unlikely
> it would be useful enough on its own to warrant another flag.

What about having tune2fs walk the inode table checking for any inodes =
that
have this flag, and only refusing to clear the flag if it finds any?  =
That
takes some time on very large filesystems, but since inode table reading =
is
linear it is reasonable on most filesystems.

Cheers, Andreas

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> misc/tune2fs.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 314cc0d0..ca06c98b 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -3236,6 +3236,13 @@ _("Warning: The journal is dirty. You may wish =
to replay the journal like:\n\n"
> 		char buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
> 		__u8 old_uuid[UUID_SIZE];
>=20
> +		if (ext2fs_has_feature_stable_inodes(fs->super)) {
> +			fputs(_("Cannot change the UUID of this =
filesystem "
> +				"because it has the stable_inodes =
feature "
> +				"flag.\n"), stderr);
> +			exit(1);
> +		}
> +
> 		if (!ext2fs_has_feature_csum_seed(fs->super) &&
> 		    (ext2fs_has_feature_metadata_csum(fs->super) ||
> 		     ext2fs_has_feature_ea_inode(fs->super))) {
> --
> 2.26.0.rc2.310.g2932bb562d-goog
>=20


Cheers, Andreas






--Apple-Mail=_3DA047BA-35EF-48C4-A8AB-ACB70041D364
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl6FS7oACgkQcqXauRfM
H+DmSQ//TkmQb/2AkeInHenVL/Fxhl2Asosr4hz+uikYf5nJMtaE5ovIX/IaAp5m
isDr3MqEy5+5LYkYhzq6l9HXrdP347zIJLXOocsTMCos9s27O4cso+vhcGm7g1yU
iJoVtTh9Lzbz0WOsuSeUHwJbKs/zc2Fuys67Iox5ZwggeiMosFDd4ntqQOo/t3fp
XswmzQGNpz4594wPSeV4wui3X/wIqb/Xja4/c2lTHl+Ixa8JLLKSobDqQnKX1ffv
mfGkujXnlIMgZsoqWFEfgWYVS8MbMIG4K+SWe0oEFgfoXQuLSBb+8OiqKLrlhoUE
mpxqNS8AaYm6PhMpm+vSexkaO+uk+PG1iwSqNjbkrcKHOqtfFoK9IIna+InzLV0p
g6Ja/CD7Kn+B1eFS1olqjuvnoeHHZRwjwfl48A7RskGo3OKWLpP9wsdYFLiD6q3Y
S4Pp4qY8azI4zaRSgO0QguPcoLRLc+alor83+O7/ZKWE2RfgNOGxrSvfYWyrDRQU
y8svRLmchmCEgBzecLCzS6OTXicgXweWDUFpHf/CdI/4fYko3y3ueVdTTFDD9BHJ
QrWnWTuJo2KEd55Ol7gl0s1SGo6emotjPq+NMQQMuEWuwPwtD0FOQ8zC2cSOxQ2J
r3c2p6GoAlGqg6jgD+OGTnla4X6OYkkGdWolM943eW7CPfswscY=
=oBpG
-----END PGP SIGNATURE-----

--Apple-Mail=_3DA047BA-35EF-48C4-A8AB-ACB70041D364--
