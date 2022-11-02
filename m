Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB30E6170D5
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 23:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiKBWse (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 18:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiKBWsd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 18:48:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199DEE81
        for <linux-fscrypt@vger.kernel.org>; Wed,  2 Nov 2022 15:48:32 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q1so97440pgl.11
        for <linux-fscrypt@vger.kernel.org>; Wed, 02 Nov 2022 15:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20210112.gappssmtp.com; s=20210112;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=cj171yfmYzsHSXMPz8MM+aTcukwosxuCRyTSCspjm7A=;
        b=GDavR2PKjclwaPcPgDus/pHDswU0YvdDE3GCccZSg3K+vWok990di8sHqeyu4rOxRl
         OtndDMqDlaj3iEuPOhbFJ1kHk8hOG9Fn1RgvE3L6Cb8jEWTctPM3UpOnb0aeSzDhIHWH
         x3RxcQbADtVh9ghhFMUkufRB/krMz79QBBaWiEeItTDdDGSglQLqxln3PWr4QA1JZUrc
         ARgFWCg9pX+BxmJB52L9HITfBbI4Nlfuplz5ryjTGIBzcXbEzBOaslncu6mCBGk8ZcFN
         QlR5LJzX4qYujyxZozH9asMRkkBnmndccMvLxeRIcTND/xhIaIaDmiTmYNfFr3mCzZHr
         KoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cj171yfmYzsHSXMPz8MM+aTcukwosxuCRyTSCspjm7A=;
        b=3js3IocWPSItwpIS9OzN+QLpjfzd5lVdi10iqK/R04ytGooCYUM31sci4QFjW1C+02
         LzTeuv66nGfkrbKPfIVhZn9gmJRBWHWdjO7VVQkirB76u0ee5wtN65O5E+5UVqEA0kAF
         2zXutYR/E/uZ6ITJsQt+/kxhdHLrVZ4oGDy1WDxXayfSSV9qX6C9kPVCkQTuGUFjDJzi
         1gDKN2FKA5SYQndAnWPgQBRSecfJdQPAWR8ebAqM5BFUznkrD8x1UprO4ViCjtg1NebM
         5ywJVVwdZsoyjcUOy20z+EMpYGIQOxASRFT5b0iKbiC9MdgpMhsFs+1TXOoN9IpMrcHZ
         DpfA==
X-Gm-Message-State: ACrzQf3ax91ODZJ1BybZUqA6yM04wOu8KpKSb2PyRvrtF371PXEVUAtO
        V31/y1RObJaOKkj4C8YBKbg5CR3Mm6oF2Ip3
X-Google-Smtp-Source: AMsMyM53HCGUgkyCoxkxdNRiNURlfSxGnzz6hEF/FRMov3WHMgN9jcKZgJgCGSBcrzW7wAUTlEiOgQ==
X-Received: by 2002:a65:644a:0:b0:470:f04:5b67 with SMTP id s10-20020a65644a000000b004700f045b67mr3617221pgv.586.1667429311502;
        Wed, 02 Nov 2022 15:48:31 -0700 (PDT)
Received: from cabot.adilger.int (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id n126-20020a622784000000b00562ef28aac6sm8906682pfn.185.2022.11.02.15.48.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Nov 2022 15:48:30 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <41A87324-A905-48A6-93F4-1DCA709B5FAF@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AEB4824A-F0CA-4C11-9F0B-2946649E9988";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [e2fsprogs PATCH v2] e2fsck: don't allow journal inode to have
 encrypt flag
Date:   Wed, 2 Nov 2022 16:48:27 -0600
In-Reply-To: <20221102220551.3940-1-ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
To:     Eric Biggers <ebiggers@kernel.org>
References: <20221102220551.3940-1-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_AEB4824A-F0CA-4C11-9F0B-2946649E9988
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 2, 2022, at 4:05 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> Since the kernel is being fixed to consider journal inodes with the
> 'encrypt' flag set to be invalid, also update e2fsck accordingly.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> v2: generate the test filesystem image dynamically.
>=20
> e2fsck/journal.c                   |  3 ++-
> tests/f_badjour_encrypted/expect.1 | 30 ++++++++++++++++++++++++++++++
> tests/f_badjour_encrypted/expect.2 |  7 +++++++
> tests/f_badjour_encrypted/name     |  1 +
> tests/f_badjour_encrypted/script   | 11 +++++++++++
> 5 files changed, 51 insertions(+), 1 deletion(-)
> create mode 100644 tests/f_badjour_encrypted/expect.1
> create mode 100644 tests/f_badjour_encrypted/expect.2
> create mode 100644 tests/f_badjour_encrypted/name
> create mode 100644 tests/f_badjour_encrypted/script
>=20
> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
> index d802c5e9..343e48ba 100644
> --- a/e2fsck/journal.c
> +++ b/e2fsck/journal.c
> @@ -1039,7 +1039,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t =
ctx, journal_t **ret_journal)
> 			tried_backup_jnl++;
> 		}
> 		if (!j_inode->i_ext2.i_links_count ||
> -		    !LINUX_S_ISREG(j_inode->i_ext2.i_mode)) {
> +		    !LINUX_S_ISREG(j_inode->i_ext2.i_mode) ||
> +		    (j_inode->i_ext2.i_flags & EXT4_ENCRYPT_FL)) {
> 			retval =3D EXT2_ET_NO_JOURNAL;
> 			goto try_backup_journal;
> 		}
> diff --git a/tests/f_badjour_encrypted/expect.1 =
b/tests/f_badjour_encrypted/expect.1
> new file mode 100644
> index 00000000..0b13b9eb
> --- /dev/null
> +++ b/tests/f_badjour_encrypted/expect.1
> @@ -0,0 +1,30 @@
> +Superblock has an invalid journal (inode 8).
> +Clear? yes
> +
> +*** journal has been deleted ***
> +
> +Pass 1: Checking inodes, blocks, and sizes
> +Journal inode is not in use, but contains data.  Clear? yes
> +
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +Block bitmap differences:  -(24--25) -(27--41) -(107--1113)
> +Fix? yes
> +
> +Free blocks count wrong for group #0 (934, counted=3D1958).
> +Fix? yes
> +
> +Free blocks count wrong (934, counted=3D1958).
> +Fix? yes
> +
> +Recreate journal? yes
> +
> +Creating journal (1024 blocks):  Done.
> +
> +*** journal has been regenerated ***
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +test_filesys: 11/256 files (0.0% non-contiguous), 1114/2048 blocks
> +Exit status is 1
> diff --git a/tests/f_badjour_encrypted/expect.2 =
b/tests/f_badjour_encrypted/expect.2
> new file mode 100644
> index 00000000..76934be2
> --- /dev/null
> +++ b/tests/f_badjour_encrypted/expect.2
> @@ -0,0 +1,7 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 11/256 files (9.1% non-contiguous), 1114/2048 blocks
> +Exit status is 0
> diff --git a/tests/f_badjour_encrypted/name =
b/tests/f_badjour_encrypted/name
> new file mode 100644
> index 00000000..e8f4c04f
> --- /dev/null
> +++ b/tests/f_badjour_encrypted/name
> @@ -0,0 +1 @@
> +journal inode has encrypt flag
> diff --git a/tests/f_badjour_encrypted/script =
b/tests/f_badjour_encrypted/script
> new file mode 100644
> index 00000000..e6778f1d
> --- /dev/null
> +++ b/tests/f_badjour_encrypted/script
> @@ -0,0 +1,11 @@
> +if ! test -x $DEBUGFS_EXE; then
> +	echo "$test_name: $test_description: skipped (no debugfs)"
> +	return 0
> +fi
> +
> +touch $TMPFILE
> +$MKE2FS -t ext4 -b 1024 $TMPFILE 2M
> +$DEBUGFS -w -R 'set_inode_field <8> flags 0x80800' $TMPFILE
> +
> +SKIP_GUNZIP=3D"true"
> +. $cmd_dir/run_e2fsck
>=20
> base-commit: aad34909b6648579f42dade5af5b46821aa4d845
> --
> 2.38.1
>=20


Cheers, Andreas






--Apple-Mail=_AEB4824A-F0CA-4C11-9F0B-2946649E9988
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmNi87wACgkQcqXauRfM
H+BMqQ/8CvUUDekSO4V1Hk3uMLri/tmSxwkFST3cvdwscpN0ffuMVomfjxpkpu6A
9fdL+vqSM7Z+U1ZCf7A4HE221mQS2BNnqGfOcfJ5oWy/2mZlvp7yRUVWdYhT3iMA
NIipg4aFDQ2wH86fAY33D3RDWB5glkh78b23W4GqlFJSBVQNAdqd6M4zj31pUkca
V5Axm3LwVqWy9WofWo3MiBA6dSxIKB9G1k8xCWAzFwjNLDlZPdJCisq6iAbkYHQB
LFMHq9ZaQdU2SSZFnagwgL2X2dKo4i+9lqDgXvEY/rmvE0OjCmnonFoDUXN1+dOp
/CLAWCe+p2vxjQ3VfSlEy4TqMUGaduZYQvdS/k2CQtTV+oX+Cnt1m2du3O1/ujRW
qzlgzfg8SMc7bgy8EQCcQ3kjdykFSEdlhBVDsoH0ce06C3WJvWog3IDIIdW773SD
zr29YXQp6XTYtgde+dwRkSQAn+t9blBRsr1loAbS80WZYeE1vauIOWwPuTR+e/sg
EGmX2E09XpVRXx0JQ/XuumRRqVnWCHEK1c/+Qz4+mHBBXjYmdYiLQ/G6rctemGTF
jxRiQtsSEBJrid14AXeRnU2v+C9eIZHRWgw9i6xhJKESKfus4lbLomh/gws026ii
wjXH3QGd2ngP+Yls/fXezbO0rfU2orATgkWNxmafmR2wLzpA3aI=
=sAK+
-----END PGP SIGNATURE-----

--Apple-Mail=_AEB4824A-F0CA-4C11-9F0B-2946649E9988--
