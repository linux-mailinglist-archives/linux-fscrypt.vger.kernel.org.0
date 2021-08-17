Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F843EEE75
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Aug 2021 16:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237910AbhHQOZh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Aug 2021 10:25:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237854AbhHQOZg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Aug 2021 10:25:36 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HE2nBx009940;
        Tue, 17 Aug 2021 10:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=eDv3kgjxlaSuE0h9+1PZ4tl3F4C1OKHijW9CnPDk9k8=;
 b=aKj9iUZrM4GKwz1Tbmm72txEMeQCVLh2uok0T3tDS1dtqIbCzXlmnjRbIb2qYk0Q3p7E
 bubrCI3dB/Gb2a3uS4jVsxodl10fmN4SIm/OSSLCq6XeQpYNozot3enr651G+CAfIFJL
 usaD74JfrQBl5/w61BPlDvpkacBpkg1RQ6X/v2fT33iFVjOPHgb4bJCRldCYIxBGEfUP
 LYoSSxIwbNz16GVL86yoxkTVffyDEV4MKX3x8O+1A39WxZNYwJqbao5uqb/PAJN2UF31
 RkMIBIqhLnvGWLFDkbB1VSeQNaplwR6UStOL36yzzKIhhMAc57msUjbyWObCtcsOX6Qc bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeua12vfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 10:24:55 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17HE30qA011101;
        Tue, 17 Aug 2021 10:24:54 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeua12vew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 10:24:54 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17HEITAm021494;
        Tue, 17 Aug 2021 14:24:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8cc6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Aug 2021 14:24:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17HEOoHk57278726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 14:24:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E504B52063;
        Tue, 17 Aug 2021 14:24:49 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.53.55])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 003335205F;
        Tue, 17 Aug 2021 14:24:45 +0000 (GMT)
Message-ID: <f4264f0a83c1b080ad2a22d63ecf1fcca87dfebb.camel@linux.ibm.com>
Subject: Re: [PATCH v2] fscrypt: support trusted keys
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Eric Biggers <ebiggers@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 17 Aug 2021 10:24:44 -0400
In-Reply-To: <b77836af-42a1-5aca-9363-d050352bd8aa@pengutronix.de>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
         <20210809094408.4iqwsx77u64usfx6@kernel.org> <YRGVcaquAJiuc8bp@gmail.com>
         <20210810180636.vqwaeftv7alsodgn@kernel.org> <YRLJmaafp941uOdA@gmail.com>
         <20210810212140.sdq5dq2wy5uaj7h7@kernel.org> <YRLvPJehAeMiYb2Z@gmail.com>
         <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
         <d4f5c2593380c82ceebae2c8782a1c440b35f165.camel@linux.ibm.com>
         <YRQF09f8st95yrFZ@gmail.com>
         <0e69a0aa394dd20347b06ae4e700aa17d52583ef.camel@linux.ibm.com>
         <a6eb6f38-b9f4-c59c-4181-2049f181e67d@pengutronix.de>
         <285cb263d9c1c16f3918c98dd36074ef16568e6d.camel@linux.ibm.com>
         <b77836af-42a1-5aca-9363-d050352bd8aa@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xx-3ZG3CK2l-ESUkYpLaEF_SRiCGCD25
X-Proofpoint-ORIG-GUID: OaepDPDCXqjhoaHKWv9ZgqODcHxwi9FW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-17_04:2021-08-17,2021-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=998 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108170086
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2021-08-17 at 16:13 +0200, Ahmad Fatoum wrote:
> On 17.08.21 15:55, Mimi Zohar wrote:
> > I have no opinion as to whether this is/isn't a valid usecase.
> 
> So you'd be fine with merging trusted key support as is and leave encrypted
> key support to someone who has a valid use case and wants to argue
> in its favor?

That decision as to whether it makes sense to support trusted keys
directly, based on the new trust sources, is a decision left up to the
maintainer(s) of the new usecase and the new trust sources maintainer
Jarkko.

thanks,

Mimi

