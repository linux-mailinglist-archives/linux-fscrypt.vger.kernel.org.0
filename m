Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3555B6C22
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Sep 2022 13:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiIMLD2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Sep 2022 07:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiIMLD0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Sep 2022 07:03:26 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6489457E22;
        Tue, 13 Sep 2022 04:03:24 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id k12so8032358qkj.8;
        Tue, 13 Sep 2022 04:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=a9VAS7SwDnhTAd4zfYsWGZLNvVj5RiswWEqqMZn2dW8=;
        b=VeaQFrSZ8jfRN/XzhwXl+XprU0Pcod/pdbB8+OfOgiXPGPsQOA7JuaWLvYbs0IuOZU
         qWbXJmmSVp6KPKNKP9YNbcaoys/sSeGQjEcCQDJqIAIEx5h6TYCtIqv1TMh11ohVUbF8
         x+NMWh6gX2SDCLaoMtjnf+viiAhlMXoopfhqkWJRz7s+mVt8RUkbgmCtFiOo0qP8nBC5
         MJuM+XIWMAPHn0/sRONVjlg31oJ10RRHI96so+p3bGkLNO6v/CH53vXnqQJ9f4X2MFzy
         ULPuhD0LcsHIsrgR2tP4xLilOLn0CfZqQyv9W+3VyyAh3RuD+ZLwkLGxYDNToqZ30958
         Bc1g==
X-Gm-Message-State: ACgBeo0YMjICdSxpxqWO5s3hikN6t7T+6q4f3/uiFMjSG+vgBB32hm6z
        1fgM/9R2sWlDiApq6AlC63DJtpJwksZ/FQ==
X-Google-Smtp-Source: AA6agR6fRAzIx+Yf8x/4Ura2uHIx7zsNlLVda7Xph5GC0uywDQuVLTbobu4X4gDHuAqAF8Os1J/IpQ==
X-Received: by 2002:a05:620a:2412:b0:6ce:62a5:e37b with SMTP id d18-20020a05620a241200b006ce62a5e37bmr1591230qkn.557.1663067002963;
        Tue, 13 Sep 2022 04:03:22 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id r22-20020a05620a299600b006ce5ba64e30sm3005025qkp.136.2022.09.13.04.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 04:03:22 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id b136so17157546yba.2;
        Tue, 13 Sep 2022 04:03:22 -0700 (PDT)
X-Received: by 2002:a25:e309:0:b0:695:864e:8009 with SMTP id
 z9-20020a25e309000000b00695864e8009mr25423139ybd.309.1663067002040; Tue, 13
 Sep 2022 04:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
 <dbb3a5ea-65d9-12bd-bde3-e16ab2f44adc@oracle.com>
In-Reply-To: <dbb3a5ea-65d9-12bd-bde3-e16ab2f44adc@oracle.com>
From:   Neal Gompa <ngompa@fedoraproject.org>
Date:   Tue, 13 Sep 2022 07:02:45 -0400
X-Gmail-Original-Message-ID: <CAEg-Je_=K6ky95ybv=Dx21bUPWjP-Vew14pu4KWVDQuYn+NTNg@mail.gmail.com>
Message-ID: <CAEg-Je_=K6ky95ybv=Dx21bUPWjP-Vew14pu4KWVDQuYn+NTNg@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] fscrypt: add flag allowing partially-encrypted directories
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>,
        Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 13, 2022 at 6:21 AM Anand Jain <anand.jain@oracle.com> wrote:
>
> On 06/09/2022 08:35, Sweet Tea Dorminy wrote:
> > From: Omar Sandoval <osandov@osandov.com>
> >
> > Creating several new subvolumes out of snapshots of another subvolume,
> > each for a different VM's storage, is a important usecase for btrfs.
>
> > We
> > would like to give each VM a unique encryption key to use for new writes
> > to its subvolume, so that secure deletion of the VM's data is as simple
> > as securely deleting the key; to avoid needing multiple keys in each VM,
> > we envision the initial subvolume being unencrypted.
>
> In this usecase, you didn't mention if the original subvolume is
> encrypted, assuming it is not, so this usecase is the same as mentioned
> in the design document. Now, in this usecase, what happens if the
> original subvolume is encrypted? Can we still avoid the multiple keys?
> How is that going to work? Or we don't yet support subvolumes out of
> snapshots of another encrypted subvolume?
>

Count this as the first official "email triggered by Plumbers" I
suppose, but I've been looking forward to Btrfs encryption for Fedora
for a variety of use-cases:

* Converting a disk from unencrypted to encrypted without reinstalling[1]
* Encrypting system and user data with different credentials[2][3]
* Mass managed systems with dual-credential encryption (one rooted in
org, other by user)[1]

The way I envision Fedora's usage of this feature going is as follows:

The system is shipped (OEM install; e.g. Lenovo, Slimbook, etc.) or
installed without encryption (from Anaconda). The firstboot process
helps the user get setup, and asks if they want disk encryption
(provided there is no policy forcing it on). If the answer is yes,
then the root subvolume and the home subvolume are configured to be
encrypted using the on-board secure enclave (TPM or whatever). When
the user creation step occurs, if disk encryption was set on earlier,
then the user subvolume inside the home subvolume gets configured to
be encrypted using the login credentials. If it wasn't set on earlier,
we could also still offer to encrypt the user data here. If this is a
mass-managed system, an additional decryption key would be available
for the system manager to use in the event of credential loss, damaged
TPM, etc.

For the cloudy scenario, we'd probably provide tools to orchestrate
this from cloud-init for confidential computing stuff too.

For all this to work, I expect the following:

* Encryption to support *somehow* any number of decryption keys/methods
* Nesting of subvolumes with differing encryption methods
* The ability to blindly backup and restore subvolumes without needing
to decrypt

On a personal system, I expect at most two credentials in use: one
keyed to the system and one keyed to the user. For a corporate/mass
managed system, I expect a third one: one keyed to the management
platform. This is necessary because in a lot of jurisdictions, you
don't necessarily own the data on your corporate laptop, and the owner
has the right to be able to access that data. But a more prosaic or
banal reason is that people forget their credentials and being able to
reset them without losing all their data is usually a good thing. :)

Hopefully I've transcribed what I said properly into this email. :)

[1]: https://pagure.io/fedora-btrfs/project/issue/10
[2]: https://pagure.io/fedora-workstation/issue/82
[3]: https://pagure.io/fedora-workstation/issue/136



--
Neal Gompa (FAS: ngompa)
