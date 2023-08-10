Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19C7774ED
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 11:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjHJJw7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 05:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjHJJw6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 05:52:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AC82130;
        Thu, 10 Aug 2023 02:52:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-99c4923195dso105448566b.2;
        Thu, 10 Aug 2023 02:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691661176; x=1692265976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfStIR3Z/TpsiTAl9VLEMssaRTKReZHkk2yays+RCbc=;
        b=MuEyyx4MLQDm2EI2blOoxDNZr3MYCMwJ1p5JIhvKwEwHLpu9W9gSe7df0zadAOOYCo
         8/pq3TsIGMK6gL7Zg6O7KuFemZQN0G/jDzy+LxkRXT7wkBmMJBjIOaN/Sxf9dLMyA7fp
         UG64WjAU8SXfFKZnKoHpnxj9vbZ9gHbakv/ZD6NibqYyYezidjlnqHno+UGJP0bToDWW
         6pcSkdbtF6mvE2PsrI0YsIsHpRHk1S6WtCe2ptoevc1gltijN9UKY4Y61RNddeHZC9Ma
         beUo1U0hGx6uKLQr/twg+Mw+kcXG/UKZpdgEmEg5T6MV7/pEz/HfEdWPqESCVoiE62kL
         7+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691661176; x=1692265976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfStIR3Z/TpsiTAl9VLEMssaRTKReZHkk2yays+RCbc=;
        b=HpWnHB86Dr3/aRc/jE0FSemGD/MdWMoUFIEYs54tqqopmp4xFlrRgDXV23LRi0Sq+V
         ZrezswFvFrSwxB049ox08nHbp24fMR1hsAUUa7RzpqRsS0ONcsFIQ2FFiMBwlDWgaQ8h
         xzXXYrk/IHis4fU+550bGJd6+rLrHQBlMz1Ol2W1J2lfqCCLxw8WNlU5HLQvTPGC7g/M
         fUygC/F29xwHrl+gxABWdKGbVsFZivNcVYQqYXyB4o4fHngklRL0umQfW7utnWdSV2uP
         W6PXURv0z6LmDF37i1gGAC4HAyKOPElkWODzJED5k4l6BMy+k7TWI1K9g480e0CE5dlk
         YeZA==
X-Gm-Message-State: AOJu0YzgnbQhcIu6zL0sAbZTAikD1GdIgA1MsgOWLSIz7eC7A30G7vtg
        MhNCGeoeg0o5Vm1qHNX09SK0/8WoqrgTKqLgtuM=
X-Google-Smtp-Source: AGHT+IHu7lSYE9m5TKhJN7om0nQ8j3M+1EHCw+ji07W8TFRTcY5lYu5ckHG+JCeLaPKTI/Mvx03SJOPOWh4J657A42E=
X-Received: by 2002:a17:906:3ca1:b0:992:91ce:4508 with SMTP id
 b1-20020a1709063ca100b0099291ce4508mr1756493ejh.53.1691661175762; Thu, 10 Aug
 2023 02:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1691505882.git.sweettea-kernel@dorminy.me> <20230810045520.GA923@sol.localdomain>
In-Reply-To: <20230810045520.GA923@sol.localdomain>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Thu, 10 Aug 2023 05:52:19 -0400
Message-ID: <CAEg-Je-W9-qAkC1JvRWAgohFDLbobYX97qbtGfqzQP2Xxapb4w@mail.gmail.com>
Subject: Re: [PATCH v3 00/16] fscrypt: add extent encryption
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 10, 2023 at 1:24=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Aug 08, 2023 at 01:08:17PM -0400, Sweet Tea Dorminy wrote:
> > This applies atop [3], which itself is based on kdave/misc-next. It
> > passes encryption fstests with suitable changes to btrfs-progs.
>
> Where can I find kdave/misc-next?  The only mention of "kdave" in MAINTAI=
NERS is
> the following under BTRFS FILE SYSTEM:
>
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>
> But that repo doesn't contain a misc-next branch.
>

David Sterba's development trees are in this repository:
https://github.com/kdave/btrfs-devel.git



--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
