Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028382CFD91
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Dec 2020 19:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgLESjT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 5 Dec 2020 13:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbgLEST0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 5 Dec 2020 13:19:26 -0500
Date:   Sat, 5 Dec 2020 10:07:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607191654;
        bh=JSA57+wXVj3H6++cCmUu4KQ3n2g1dHCJ+HE2fOPCu7k=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ate+WiDGkniHDrd4oMP+wlyQRLsHcNcrjsCTSY4NyGAkh0BtMKxzACsMMFDEi1IBz
         ONc/ZdIiSFS1hInll8vjr0iR53fB56WaqPzTZWTGzQ8Z4M04nDzjYcQLn/klyapKRG
         X9tQk107SKfswxa6sVVQ2oP+BQfG3TqoU1WZEVeQn6I5lDnWHa7XkKf+hY0mOEbMiZ
         ZBGxbHtMq5OAygyCBBzfuPy3oBbsizI1rTVm1AMVCp594Svj2VUitx/XkO4Ftfz1Qg
         3qzxIZf7yELgBbq3mszSLFltYBNTJlBdLWRxHCw7Yo54TAicatAsbb5quwbQd5D+1e
         hsFKjcH6s736g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v2 4/9] mmc: cqhci: add support for inline encryption
Message-ID: <X8vMZBSP0hQSOqlA@sol.localdomain>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-5-ebiggers@kernel.org>
 <X8t82HijJtbHVyLM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8t82HijJtbHVyLM@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 05, 2020 at 12:28:08PM +0000, Satya Tangirala wrote:
> > +#define CQHCI_CRYPTO_CONFIGURATION_ENABLE (1 << 7)
> > +#define CQHCI_CRYPTO_KEY_MAX_SIZE 64
> > +/* x-CRYPTOCFG - Crypto Configuration X */
> > +union cqhci_crypto_cfg_entry {
> > +	__le32 reg_val[32];
> > +	struct {
> > +		u8 crypto_key[CQHCI_CRYPTO_KEY_MAX_SIZE];
> > +		/* 4KB/512 = 8 */
> I'm not sure what this comment is for (admittedly, it seems I introduced
> this line into AOSP, and that seems to have made it here haha) - I think
> we should just remove it.
> > +		u8 data_unit_size;
> > +		u8 crypto_cap_idx;
> > +		u8 reserved_1;
> > +		u8 config_enable;
> > +		u8 reserved_multi_host;
> > +		u8 reserved_2;
> > +		u8 vsb[2];
> > +		u8 reserved_3[56];
> > +	};
> > +};

(Please quote just the part that you're actually replying to -- thanks!)

The comment gives the typical value that is stored in data_unit_size,
but yeah it's a bad comment.  I'll just remove it.

- Eric
