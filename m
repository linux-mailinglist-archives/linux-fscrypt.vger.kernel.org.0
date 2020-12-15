Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED7A2DB30E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Dec 2020 18:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgLORxh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Dec 2020 12:53:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbgLORxf (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Dec 2020 12:53:35 -0500
Date:   Tue, 15 Dec 2020 09:52:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608054774;
        bh=hXPUuO6IQOjzr+sj64k3SZ3Y/yxjs2z8ZppnJqErAEY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=AiwUOOqvaALNAa9kg0a9Xkvn6d23jW8jD9fP+LVg2rXai4DOh4cO3mjtIZ0IOVVr7
         6ov6RTxQKV5w3EfPaJ9jv3zxQuPWUFenCJimYmHh5q1+HsK6Rj9XLwfy6FUnv2KEi8
         FliGXAEN5tD/Yf36A/5PRI2uevdO+kniLNZl//xdR2mXZGcZcOTnf/1iDSfCVAZwjU
         kRE/jkZHyAnnZMlzK3Ax92N/rltQZ+VOcKAEfTjtONe5No0igt14hYQVpVYG1ox1/w
         IE8+oTUiTcWFs+8VHBO62il6badS9NyKNETNe+d9L3bdyxDubAaqvQyA8qPTIyir4y
         aQ7iAiSlzMTVA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Peng.Zhou" <peng.zhou@mediatek.com>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v3 0/9] eMMC inline encryption support
Message-ID: <X9j38+54HGOEK7C/@sol.localdomain>
References: <20201209044238.78659-1-ebiggers@kernel.org>
 <1608019654.31445.8.camel@mbjsdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608019654.31445.8.camel@mbjsdccf07>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 15, 2020 at 04:07:34PM +0800, Peng.Zhou wrote:
> > 
> I had verified this patchset in MT6853 (A 5G mobile smartphone platform
> of Mediatek which meets eMMC v5.2 specification) and they work normally
> in Android environment.
> Reviewed and Tested by: Peng Zhou<peng.zhou@mediatek.com>

Thanks Peng.  Is your Reviewed-and-tested-by for the whole patchset, or just for
patches 1-5?  Patches 6-9 only affect Qualcomm hardware.

Also, were many changes to mtk-sd.c required to get the crypto support working
on your hardware, or was it just a matter of making a SMC call and setting the
crypto capability flag, like it was for ufs-mediatek (commit 46426552e74f)?
If you could send your patch for mtk-sd.c on top of this patchset, that would be
helpful for people to see.

- Eric
