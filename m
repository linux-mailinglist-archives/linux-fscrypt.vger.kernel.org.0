Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CFB2DDD10
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 03:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgLRCws (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 21:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727196AbgLRCws (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 21:52:48 -0500
Date:   Thu, 17 Dec 2020 18:52:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608259928;
        bh=glTni2yTCAf7pO5CWMTAn773citvpvX44WaT6+KZheg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=J9Dz65ZH8ugz3R0xddaHBSP0u5WZ3I31gIUvvxQxiAeLigOmwFRkw8EY8pDOVuLbP
         VHOTjNHsCTDQQ62grA1nt0f7AZWE6qeV2uXtO8+KSbOCGoEDy/oyglmb2GwdmpSW+W
         +fCzHZPINwY8IxnjLPb147RgtoEe8SZ/vgyaJkBxoWCWiJlkx67o80ictuIbXGvbH4
         Mpgell7WjI4+rU6h/kS6nJzNWkbqZ/pv9bMJ+gVqQisLYv714eDvt7QNhS+UnojZ2n
         e8fYKntXlZhmGeERYfuzhX4aTCpFhv9U5cuNxbDT6vaHTYS6mEDXd4ZrVwvRF9Iim8
         E5Y0ywykRGA7A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Peng.Zhou" <peng.zhou@mediatek.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        kuohong.wang@mediatek.com, gray.jia@mediatek.com,
        StanleyChu <stanley.chu@mediatek.com>,
        peng zhou <peng.zhou@medaitek.com>
Subject: Re: [PATCH 0/8] eMMC inline encryption support
Message-ID: <X9wZVvOIH4diFqWn@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <X7gQ9Y44iIgkiM64@sol.localdomain>
 <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
 <X7gcsC6IS80sUy4K@sol.localdomain>
 <9010afea-1075-8f72-99c7-c471840685db@intel.com>
 <X7xpbJf4gDcFdEc/@sol.localdomain>
 <1606294991.31568.5.camel@mtkswgap22>
 <1608196892.11508.0.camel@mbjsdccf07>
 <X9uhVj080rvyhAVl@sol.localdomain>
 <1608248441.2255.5.camel@mbjsdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608248441.2255.5.camel@mbjsdccf07>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 18, 2020 at 07:40:41AM +0800, Peng.Zhou wrote:
> > > Hi Eric,
> > > 
> > > I also have a question about reprogramming keys scenarios, if some SoC
> > > vensors' eMMC host will power down or something else like that keys will
> > > be lost after runtime suspend, that means we must do reprogramming keys
> > > in runtime resume, right? Do you think that we should add it in
> > > cqhci-core layer(such as __cqhci_enable()) or every SoC vendor's host
> > > driver resume path?
> > > 
> > 
> > The keys should only be lost on reset, not on runtime suspend.  So I believe the
> > code I've proposed is sufficient.
> > 
> > - Eric
> 
> That's a little too absolute for me...anyway that's my concern for much
> more SoC vendors who want to be compatible with your framework in
> future.Thank you for explanation.

But the current approach works on all the hardware that's been tested so far,
right?  And programming the keys can take a long time, so it shouldn't be done
unnecessarily.  (I've heard it's fairly fast on Mediatek SoCs.  However, with
Qualcomm ICE it takes longer.)

It seems that host controller configuration typically doesn't get lost during
runtime suspend, and the keyslots are no exception to that.

And if (hypothetically) a host controller that adds crypto support in the future
actually does need to restore the keys during runtime resume, it can just do it
in its ->runtime_resume() method.

So from what I can see, there isn't anything else we should do for now.

- Eric
