Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC5363B6BC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Nov 2022 01:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiK2ApD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 19:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbiK2Aoy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 19:44:54 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2B540902
        for <linux-fscrypt@vger.kernel.org>; Mon, 28 Nov 2022 16:44:48 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m19so610832wms.5
        for <linux-fscrypt@vger.kernel.org>; Mon, 28 Nov 2022 16:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qH5393FoeArI9bVQyRZuU05qkYTgUZrqZNUytEetQ7k=;
        b=IIKhcbTpsKA6tj1MQtuQfDk8BRv6pIR17gXNObCJG/gv0PlzGnoLNf5FP9pD9+bKtH
         6/E9PvIxqai79XmA6HM5KqgmMx2AOkSP2J5wmYj484uiPBYBNs73RubtNW9kdjlNyIeg
         E+Qnrh3icmuy274hNq/YMXKouo/0JxzFHS6iITC7hppjaT367uDejphzfHeF/csnh8FT
         NW+e52D/PnUvoU2NxPqlrsCLa1QgJ8PRkRYy/J5DjwahxOF0R1fdTzzDNt/6vgl7n+8k
         NIxNcqydvpr/fcrcHHmCXqgFkgIBMeK2PBxUm2TEchYWkgf+i4g9jID1YFOhgHDTWs2Q
         Z9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qH5393FoeArI9bVQyRZuU05qkYTgUZrqZNUytEetQ7k=;
        b=btklJKhDw+AF6E4KG/coAoaT6geA/lD18cDNcEDClGQPrWY1K8TN2orRzJkzrp9vzq
         G0c+OKtMBkK6IEteKtv7l2u1HzGjU2/uZdrRRw0z2RADK0CB5M7meac3jGGHp3MNNVzg
         PuoDP+u7BZhIbnKbBvflcGGY8bcnZAFDgSGdkF2Naohje1qAIaqNY9DINldgspDzNsfL
         1x605bQ2KNAEoGDcUF0hWFDV1dybH1xB1qrybUSPvuOD3EjMCaNV2AAFtwbMO3EatVGl
         +ru7RCByoyQrkoTj9MR0wUq6GGDlOQOkPHerg8+rW1hnTl700BsPDAUMhx3U/5ZlDVax
         l0Gw==
X-Gm-Message-State: ANoB5pkU79FUUQ5jzkvAHvswwZyVmH+25ZjXN6bieQp45bCnSDWdOURR
        1xaZyMhH+ZhhhsbNI/wJddstDtUwAAnpXTlKF+rrFg==
X-Google-Smtp-Source: AA0mqf4l8SyjZifyI2k2X6JLXeP3aBkqHwt3jWBkEBewaRO6ilUbxpVBhWO9lqAERpmMr0XihD3mkgRzTgAC5hn371A=
X-Received: by 2002:a1c:770a:0:b0:3cf:ab80:b558 with SMTP id
 t10-20020a1c770a000000b003cfab80b558mr42795271wmi.155.1669682686564; Mon, 28
 Nov 2022 16:44:46 -0800 (PST)
MIME-Version: 1.0
References: <D3AF9D1E-12E1-434F-AEA4-5892E8BC66AB@gmail.com>
In-Reply-To: <D3AF9D1E-12E1-434F-AEA4-5892E8BC66AB@gmail.com>
From:   Victor Hsieh <victorhsieh@google.com>
Date:   Mon, 28 Nov 2022 16:44:33 -0800
Message-ID: <CAFCauYOuVrSFmeckMi+2xteCcuuCfsuNtdMB0spo2afcGOxSeg@mail.gmail.com>
Subject: Re: Feature proposal: support file content integrity verification
 based on fs-verity
To:     liuj97@gmail.com
Cc:     Eric Biggers <ebiggers@google.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, fuse-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Nov 17, 2022 at 9:19 PM Gmail <liuj97@gmail.com> wrote:
>
> Hello fuse-devel,
>
> The fs-verity framework provides file content integrity verification serv=
ices for filesystems. Currently ext4/btrfs/f2fs has enabled support for fs-=
verity. Here I would like to propose implementing FUSE file content integri=
ty verification based on fs-verity.
>
> Our current main use case is to support integrity verification for confid=
ential containers using virtio-fs. With the new integrity verification feat=
ure, we can ensure that files from virtio-fs are trusted and fs-verity root=
 digests are available for remote attestation. The integrity verification f=
eature can also be used to support other FUSE based solutions.
I'd argue FUSE isn't the right layer for supporting fs-verity
verification.  The verification can happen in the read path of
virtio-fs (or any FUSE-based filesystem).  In fact, Android is already
doing this in "authfs" fully in userspace.

Although FUSE lacks the support of "unrestricted" ioctl, which makes
it impossible for the filesystem to receive the fs-verity ioctls.
Same to statx.  I think that's where we'd need a change in FUSE
protocol.

>
> Fs-verity supports generating and verifying file content hash values. For=
 the sake of simplicity, we may only support hash value verification of fil=
e content in the first stage, and enable support for hash value generation =
in the later stage.
>
> The following FUSE protocol changes are therefore proposed to support fs-=
verity:
> 1) add flag =E2=80=9CFUSE_FS_VERITY=E2=80=9D to negotiate fs-verity suppo=
rt
> 2) add flag =E2=80=9CFUSE_ATTR_FSVERITY=E2=80=9D for fuse servers to mark=
 that inodes have associated fs-verity meta data.
> 3) add op =E2=80=9CFUSE_FSVERITY=E2=80=9D to get/set fs-verity descriptor=
 and hash values.

>
> The FUSE protocol does not specify how fuse servers store fs-verity metad=
ata. The fuse server can store fs-verity metadata in its own ways.
>
> I did a quick prototype and the changes seems moderate, about 250 lines o=
f code changes.
>
> Would love to hear about your feedback:)
>
> Thanks,
> Gerry
>
