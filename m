Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCF862C999
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Nov 2022 21:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiKPUJE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Nov 2022 15:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiKPUJE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Nov 2022 15:09:04 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC88627F8;
        Wed, 16 Nov 2022 12:09:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso3361570pjg.5;
        Wed, 16 Nov 2022 12:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PK4dr6Xpaj+nrLVZkIs8m0VdlhVtjg5TFRSgdGBFkpc=;
        b=WUQv8TXAgQ3jnea2yMv8w4gLiSR/V5JewnERpwTMq0nxAkRxol+4qzWTlWlSbyu/Bs
         G+mtYxFlbzbqDv7pkReuuSjWglQWipqAqzH37nH73kZZpq4rr2CI64Tda6sm/3QMBpRw
         LU6o09TIUNDW8p6jArfw2DU/jmi6SVC1sJ3hYQjPdNGn1tiEehtjtozX3Ptz3vOMU69w
         Fkg6OMzERWv+62uzH1DKOZiXJCkJJilc5v5TC/Dyr0B4889SDfkdWg1yyCGjCT4R61wH
         Uoys9A13FICRmamQNAlbP5ZLdpkisptFCupiXQMfLP8dFgmXOL9qBuqdgSF9iYiJqtom
         VQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PK4dr6Xpaj+nrLVZkIs8m0VdlhVtjg5TFRSgdGBFkpc=;
        b=ABxOpOxa8H7nerQTM9skIKi1n0rh2eF1R113XIVAk1aBlpK0JNXuC+WQ6MT+uZSwKO
         /8/ZPEEG9V04P5dTRNW/AgHkFTNB2zjqEjvaneRsDH7tX7uUu6BLezIZJf+5hNbiJKs8
         Sec4GjQ0ynjjoC1tMtZov40AhBYRzPc7t76X29rZafbou87GLAwuwACRdKEfeAjyHYT8
         +RM75mfT+seNINBPkf4xlUVprM85RnmMXgg2QXCwKu4IqVS5zmV31ksaGlhweMKNrtD0
         5L0Vu24/aE2ICGIUbphcey55C2LuqU8UnoW0171PDujRe6Yzfy19ENoYvwxxxB/u6wmN
         oYYQ==
X-Gm-Message-State: ANoB5pnkzT3gEvcMvEsSDQcVOSnwNUdxcsgZSGGIroi+qYd8gQK67ecX
        Sc0HiAa2L90cyy4RcfkrWHnh+BedevZu3TgiYDc=
X-Google-Smtp-Source: AA0mqf74Ku4MO3tsUbr1EvcpMah5UwpVOgwq0KLHsuO+npT4Wh2+ZTvJAL8F1z5n+Js5MGbwC6n4tevFPuDXrqMQDYM=
X-Received: by 2002:a17:902:d716:b0:186:b3cb:3b85 with SMTP id
 w22-20020a170902d71600b00186b3cb3b85mr10625554ply.96.1668629342700; Wed, 16
 Nov 2022 12:09:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1667389115.git.sweettea-kernel@dorminy.me> <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
In-Reply-To: <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Wed, 16 Nov 2022 15:08:26 -0500
Message-ID: <CAEg-Je96DB34Dj9_-DtgEHaiLf+omXoZTnK71Wv2f6bcWjE0yQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
To:     Paul Crowley <paulcrowley@google.com>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
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

On Thu, Nov 3, 2022 at 3:54 PM Paul Crowley <paulcrowley@google.com> wrote:
>
> Thank you for creating this! I'm told the design document [1] no
> longer reflects the current proposal in these patches. If that's so I
> think it's worth bringing the design document up to date so we can
> review the cryptography. Thanks!
>
> [1] https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk=
9ALQW3XuII/edit

So this might be my ignorance here, but when I look at the patch set,
I don't really see any significant mathematics or cryptographic work
going on here. This seems to be primarily just interacting with the
fscrypt stuff that exists in the kernel already.

Could you please clarify what you mean here?


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
