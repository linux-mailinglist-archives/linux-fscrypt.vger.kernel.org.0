Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A44F616F33
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 21:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKBUzN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 16:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiKBUzM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 16:55:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57508A46E
        for <linux-fscrypt@vger.kernel.org>; Wed,  2 Nov 2022 13:55:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso3006733pjc.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 02 Nov 2022 13:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20210112.gappssmtp.com; s=20210112;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/8ADIFndQOnIrALBDqQjN84YmHUMrBD46NGumZr+MnE=;
        b=XoPJ2Fn/YZqbR/iF40bP5tvj2ZBXyM/0KhvCULrGjMso0dL0Eh+M9G040gWnFCi6P4
         ZgDH89GjSsB4Q+y7X85PH+xE0X1tjQIX5INr/jzGBgc9O6D5YolznmHxwLomDqn23ZIO
         z0ZX+NBUeWHQ2CXTPflL5nHTid8amzuOZM9LjCpf9epQxTszX0x4s/JkBFmkgDBLydEU
         yLdkA9h/N80PJw90Xw+t2kkzjP165lB4acANSbMFbZgnd9ZncUG0rIgSLjtGvli1by5z
         4Ftlnqc10LsZgmWBNa4rppDzGq/3ikYT8NFwVnEfHCWHqP0nFiH/Woh4z3LP37tjSfzF
         pWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/8ADIFndQOnIrALBDqQjN84YmHUMrBD46NGumZr+MnE=;
        b=yzjVETjwZcRKBKzkXqjIfBHTpFev71rKzuDMaH+YO8gbA878ETaXjRFljZUAtctN6V
         byulU5ku+d8kQCY5LcU/hsqoi3+XO3itlEsv55NOvadibyW7iYGrSyOrqSJayO8413so
         lepPSNm7sdvPNG+Wt2d0yhkQ8MD2BFdONU6roLeJBf/CrcKuVpuk66C8b2I2HLioS6fN
         wOTVnKFgwsI/S8qMc+qdjphmRj8gJ8oK5xSQU95tBd36Y2WBfAGrNwv1SuJwNm8eOIdj
         rN2YzcnFW23mdUv+R0SVvhz06QLgSjtzY2Z9YUfAh4RadUcrnx2l7/zfWHGsxY4TS9tU
         0wgQ==
X-Gm-Message-State: ACrzQf3ncuOfWg2Ge7xYM8PvO2UG3IZMtbFieVWLnsa36VNhM3U696I5
        Uy5o4YMLHofk0MGqxapiDujBzg==
X-Google-Smtp-Source: AMsMyM7eGSg+xKaY5ZBjDQLMIA0JXMa9OOywmTtfcsm8AWzpW0Z3Il/osMMJwtjbPfaRCX7bx0Pocg==
X-Received: by 2002:a17:902:d70e:b0:178:2d9d:ba7b with SMTP id w14-20020a170902d70e00b001782d9dba7bmr26455002ply.90.1667422508786;
        Wed, 02 Nov 2022 13:55:08 -0700 (PDT)
Received: from cabot.adilger.int (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902f38100b00176ab6a0d5fsm8770542ple.54.2022.11.02.13.55.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Nov 2022 13:55:07 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <B8D39676-D175-4AC9-B74B-95D4AAF03A9A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_F738C8B4-8AF1-4535-832F-B00CDB8CD548";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [e2fsprogs PATCH] e2fsck: don't allow journal inode to have
 encrypt flag
Date:   Wed, 2 Nov 2022 14:55:05 -0600
In-Reply-To: <20221102053554.190282-1-ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
To:     Eric Biggers <ebiggers@kernel.org>
References: <20221102053554.190282-1-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--Apple-Mail=_F738C8B4-8AF1-4535-832F-B00CDB8CD548
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 1, 2022, at 11:35 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> Since the kernel is being fixed to consider journal inodes with the
> 'encrypt' flag set to be invalid, also update e2fsck accordingly.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> e2fsck/journal.c                   |   3 ++-
> tests/f_badjour_encrypted/expect.1 |  30 +++++++++++++++++++++++++++++
> tests/f_badjour_encrypted/expect.2 |   7 +++++++
> tests/f_badjour_encrypted/image.gz | Bin 0 -> 2637 bytes

Good to have a test case for this.

In the past Ted has asked that new test cases are generated via mke2fs
and debugfs in "f_XXX/script" file rather than a binary image, if =
possible.
That avoids saving a binary blob in Git, and also makes it much more
clear in the future what is done to the filesystem to corrupt it, rather
than having to reverse engineer this from the bits on disk.

Something like tests/f_dup4/script is a good example of this.  You may
be able to use something as simple as the following:

    touch $TMPFILE
    $MKE2FS -t ext4 -b 1024 -J size=3D4 ... $TMPFILE 16384
    $DEBUGFS -w -R 'set_inode_field <8> flags 0x800' $TMPFILE
    . $cmd_dir/run_e2fsck

It might be more involved, depending on how the journal was corrupted.
For complex debugfs changes, it is better to use a "here" document to
perform multiple commands than running debugfs multiple times.

The script is also much more compact than the binary image, and =
tolerates
changes a lot better as well.

Cheers, Andreas

> diff --git a/tests/f_badjour_encrypted/image.gz =
b/tests/f_badjour_encrypted/image.gz
> new file mode 100644
> index =
0000000000000000000000000000000000000000..660496ea5bba9b5589e6ce522feb998a=
56ab946a
> GIT binary patch
> literal 2637
> zcmb2|=3D3oE;CgwMHnR%A}ly$iH+hCjen-$w~Z}VkIC+6NxyCc!NYR5sNh}+xBbE4nR
> zN&o!s6aW5(lcp<{UH`qxzUS4ptP5pfA=3D=3Dwwf8L3{|MOkc?r&esd8Bgo#^iqA5gFQC
> z<@R-dVr@lCdHkR5{rAnDhwlG>jraZU^QHBbXJlmsKi|6fW!ukpZ~6bfSpUB2;pTmx
> zj{M*I=3D+61|wWkw4%t_n+w)pIx)GIr3+pcz<UH*C1)vHaf+5&5L-JN;=3DTiBLGj=3DQD!=

> zvwYR3oA+2BEcm`&zU2O)tkADJdjH<PwxLjZ&!1oZHNUt0v)ga`;{kvAnl~H3enld#
> z$+@%1mc~a}A54fin`clHvi0Skf*&i~udaD@=3Di-@%?sorPp11i^EC2t^@q3p&nP$X3
> zzi$!s_i3c{*ZQX!$^Q>{-utf_{{O+ORnhK@!q@)4KVSKq`3wIq_AmS|<S*DSsCW3^
> z@Q?8?^DlP4J^%iH{<8evDyi)kD?Tqg`0VhxvhA|(9o0n`65ek4mi5+?8xj$4$636y
> z`F^c@U-jvQi=3DWK?|9-~qcRR0El+UlfvVnKm_Je1l*?MoM1?axIu;=3DxksEaRLt^f1+
> zcI>}%!KM17_pFRy`>QV2pCx6B<9`)>o$;~a`cLx=3D*Y;<@Z|{cwUm;riQQi9d{>A@(
> z&c6T7uKx1sm(kDuuPD6Dvs!ev|MSq*t68t|F8)>W`}uD3t6l#pUM)HIKYZ_&&TqRj
> zWsCn;=3D6#)UcWr%}?)}rh(#y8)a4!C~Kik#*_w$dx|Fgp#PX@#7>W*1KzH66-US2JE
> z^-NZn>F!y<XV*Rp{k)o$kqqNTwTy<qXb9jBf%d~z-yS%C)HqDo|5YJ89>4NY+0hUf
> k4S}H$0uFBvZUnjWfI|K2%r`6YXzOOCSzdj93=3D9ek0BUk;ZvX%Q


Cheers, Andreas






--Apple-Mail=_F738C8B4-8AF1-4535-832F-B00CDB8CD548
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmNi2SkACgkQcqXauRfM
H+D6Ag//WGQEg7Rk/DpzwGYxVQbpNdy7mrvDN5zPPJZG0ZyJNoh/TKhRaOc/00jX
oAAfQv49V7hF76Hwr+uyD163w/xV8Aa6Grswlqdq0t1XyklfJOVFmTpIVfIb3dLg
cvuyHNedx8KPHmxgs/ztv1MU4q59w9/G6LXWOiWltQC3rI1gjhCYfd9YnqxRtMZb
nwssdswyPuOyI419qYco7t1e4Fmdgp23bd1hX+WyUDSLiagQajts7xMEn0iWOj1k
Pkuv3MupcniYwcftM0nQQARzK0c3XetwVmFS1cwdxD1lq0c9wjTlkig1lpQCvFYR
s+ka/HMojr29ch9K0OY4PWv2wU2M4PvlkxwYLlgIPkeY388Sh8VZTWbeGEc0ZJcB
TQQdsDlsm2L4EsCSiTTsap/0H1/i5uIoL0u53VizFu808cM1eb1TQrU3yBh8EQN6
LY2JRM6IDFlmG8PQUWt75UYev9KsSGSANWru4Dl4DPX0MX5JIcDSBfFKaR4ZSXOE
IOqj+KOGPyRorVyFnEmEZ1Gb4kcE0qhkCWCjrAZXM+bhRMXjBwQV5cOL4liOP56k
ChB7uNZ/VgBWruq//1c6w0P0BLaDrxXx+G6mP5nYH7DnLl/hFCqj4GMqJtp4/uMI
F+inn+281xDTv2ZL6Zkp56vMy3thO8PKf/h/aj7gVT3ciq4caHM=
=DuZ8
-----END PGP SIGNATURE-----

--Apple-Mail=_F738C8B4-8AF1-4535-832F-B00CDB8CD548--
