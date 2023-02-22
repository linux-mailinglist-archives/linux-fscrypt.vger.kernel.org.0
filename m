Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704A569F3B2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Feb 2023 12:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjBVLx4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Feb 2023 06:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjBVLxd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Feb 2023 06:53:33 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5F628D02;
        Wed, 22 Feb 2023 03:53:32 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b12so29241958edd.4;
        Wed, 22 Feb 2023 03:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FiBrAdemLV+AmYoulvodfUtc9pdmXWDOyYsETDsNOdA=;
        b=Z0LtkuKbOYzy9CrRbRhHWfpIy9RoM1KAAxMmagwVMQw/OtXo8WVAsZ5YhPbJv2weyC
         Y67zncqfvJIOHtJH0YBzCKuII1+dPwz7FRvG0o+N/jRS+fE8Hi1G2T+WLn+xOkYco13y
         NJPMw9pJfqGUCd5Elkn9xbWU+dWpYiKLxwMbx7JarO7Ua5avAx1Waq6DsDZaivboLgFo
         vGkOmHU2g+OPbGFvkpclb9lLTnZAaF5rn4j5HYAJcW+hZkAHNpGAZzDcRV869jEWRsia
         I5kx+SSGDRB9Nr5F61JNknES82Jf/xRgQyhGEaHp+4MkIL1j8wmVflZMUvdlu4wpIKL6
         HCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FiBrAdemLV+AmYoulvodfUtc9pdmXWDOyYsETDsNOdA=;
        b=qlcVrMhHIff7pqqFbJYb/vcsdQICH70Nt5r12ygD9NC+RDgXL5iSOasNWznB8Lkoj4
         4GPUSi/pjCO+V8Lb1zOUaZbbZ6L4WyrcMivYXeUOLiGvOg631totEHdOQRquApG26ZD2
         DEXE4PlMFAxAiXr7QSV+Cn0E0qoOt9L20tnbVf6mtPMuvQ5vpsP9lo0VHTUizJnslfEQ
         /oRXaonKmd8mO1RVr33pZ0CQkySnt82DIormT9cQ2HrHHTu+yQkUusSLBlxzanjgSbLf
         8yv0iTsacTIlTYpEW4ttmH9OM/G1RJx9eiwp2lqCWUFenOwNrdlg3/tateJr9V/Mk2lU
         RiiA==
X-Gm-Message-State: AO0yUKWqXWGlJierbzzFoij1iJ7sLU7d4rjyok3YaQW5uH84sYi1U9bM
        4UuZMvhbzfGgqhyaEh8dLIREWuFpIctp1ucxpRI=
X-Google-Smtp-Source: AK7set/L9XsLOr4BLXG8yAEiZE4T6yB4ArFxgRdpl8UjV0OWnGhmDov5GvajoPNyjdWzMm/L36OcvG14eUP2+UavcN8=
X-Received: by 2002:a50:d619:0:b0:4ab:3a49:68b9 with SMTP id
 x25-20020a50d619000000b004ab3a4968b9mr3575896edi.5.1677066810689; Wed, 22 Feb
 2023 03:53:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Wed, 22 Feb 2023 06:52:54 -0500
Message-ID: <CAEg-Je-tcpu0u2TekzjrtQ4x0PQtV_1A300WxAiTVswjKbJjYw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] fscrypt: add per-extent encryption keys
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 1, 2023 at 12:08 AM Sweet Tea Dorminy
<sweettea-kernel@dorminy.me> wrote:
>
> Last month, after a discussion of using fscrypt in btrfs, several
> potential areas for expansion of fscrypt functionality were identified:
> specifically, per-extent keys, authenticated encryption, and 'rekeying'
> a directory tree [1]. These additions will permit btrfs to have better
> cryptographic characteristics than previous attempts at expanding btrfs
> to use fscrypt.
>
> This attempts to implement the first of these, per-extent keys (in
> analogy to the current per-inode keys) in fscrypt. For a filesystem
> using per-extent keys, the idea is that each regular file inode is
> linked to its parent directory's fscrypt_info, while each extent in
> the filesystem -- opaque to fscrypt -- stores a fscrypt_info providing
> the key for the data in that extent. For non-regular files, the inode
> has its own fscrypt_info as in current ("inode-based") fscrypt.
>
> IV generation methods using logical block numbers use the logical block
> number within the extent, and for IV generation methods using inode
> numbers, such filesystems may optionally implement a method providing an
> equivalent on a per-extent basis.
>
> Known limitations: change 12 ("fscrypt: notify per-extent infos if
> master key vanishes") does not sufficiently argue that there cannot be a
> race between freeing a master key and using it for some pending extent IO=
.
> Change 16 ("fscrypt: disable inline encryption for extent-based
> encryption") merely disables inline encryption, when it should implement
> generating appropriate inline encryption info for extent infos.
>
> This has not been thoroughly tested against a btrfs implementation of
> the interfaces -- I've thrown out everything here and tried something
> new several times, and while I think this interface is a decent one, I
> would like to get input on it in parallel with finishing the btrfs side
> of this part, and the other elements of the design mentioned in [1]
>
> [1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7=
iDaCDQQNZA/edit?usp=3Dsharing
>
> *** BLURB HERE ***
>
> Sweet Tea Dorminy (17):
>   fscrypt: factor accessing inode->i_crypt_info
>   fscrypt: separate getting info for a specific block
>   fscrypt: adjust effective lblks based on extents
>   fscrypt: factor out fscrypt_set_inode_info()
>   fscrypt: use parent dir's info for extent-based encryption.
>   fscrypt: add a super_block pointer to fscrypt_info
>   fscrypt: update comments about inodes to include extents
>   fscrypt: rename mk->mk_decrypted_inodes*
>   fscrypt: make fscrypt_setup_encryption_info generic for extents
>   fscrypt: let fscrypt_infos be owned by an extent
>   fscrypt: update all the *per_file_* function names
>   fscrypt: notify per-extent infos if master key vanishes
>   fscrypt: use an optional ino equivalent for per-extent infos
>   fscrypt: add creation/usage/freeing of per-extent infos
>   fscrypt: allow load/save of extent contexts
>   fscrypt: disable inline encryption for extent-based encryption
>   fscrypt: update documentation to mention per-extent keys.
>
>  Documentation/filesystems/fscrypt.rst |  38 +++-
>  fs/crypto/crypto.c                    |  17 +-
>  fs/crypto/fname.c                     |   9 +-
>  fs/crypto/fscrypt_private.h           | 174 +++++++++++++----
>  fs/crypto/hooks.c                     |   2 +-
>  fs/crypto/inline_crypt.c              |  42 ++--
>  fs/crypto/keyring.c                   |  67 ++++---
>  fs/crypto/keysetup.c                  | 263 ++++++++++++++++++++------
>  fs/crypto/keysetup_v1.c               |  24 +--
>  fs/crypto/policy.c                    |  28 ++-
>  include/linux/fscrypt.h               |  76 ++++++++
>  11 files changed, 580 insertions(+), 160 deletions(-)
>
>
> base-commit: b7af0635c87ff78d6bd523298ab7471f9ffd3ce5
> --
> 2.38.1
>

I'm surprised that this submission generated no discussion across a
timeframe of over a month. Is this normal for RFC patch sets?


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
