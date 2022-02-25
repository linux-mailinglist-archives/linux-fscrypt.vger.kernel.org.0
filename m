Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE604C4F3B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Feb 2022 21:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiBYUCX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Feb 2022 15:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiBYUCW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Feb 2022 15:02:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D41AA061;
        Fri, 25 Feb 2022 12:01:50 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PJhhQV016324;
        Fri, 25 Feb 2022 20:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5pPmbcYAkuzYVHh5IMiI//wK5akxlgR4+/kcgP2FE9U=;
 b=jJqTNYvE7zSNqE1phR8v46kk+JgKvw/lI38/BRTaxbC6rnZLMd58ZwReMdByDvCBm6sD
 z6JgaKA1K81cUqPelKTqPoxgz5Nf8WM0DZY4wA4STVM4dogrG1lmKTvbP5G2MuTyuofb
 rMz7Avoa07HbHnUpEkOiZUS+6Ud1n02p4706xStmNMWFMkHHPmmONszkAW7yvYFdE/yA
 5Jqo7FoRXg+yL3RmnmHBAJ3cld7valbvpDyfjyCFi52GZqRPOyIwO4kor3zT/os/u7oj
 oR8EkehhtPmcS3wfrBevuy8K3tpoq+XzQj/zZNVahmOL8+5pDy9HT2QIFk6CyZlMMSQ0 jw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ef5h9gafc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 20:01:48 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PJm7CY004396;
        Fri, 25 Feb 2022 20:01:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3ear69rdw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 20:01:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PK1hYL19857868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 20:01:43 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB1E24203F;
        Fri, 25 Feb 2022 20:01:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C84BE4204B;
        Fri, 25 Feb 2022 20:01:42 +0000 (GMT)
Received: from sig-9-65-82-248.ibm.com (unknown [9.65.82.248])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 20:01:42 +0000 (GMT)
Message-ID: <c848c7a19d1557d9038d3bdd64a67385aa788c8f.camel@linux.ibm.com>
Subject: Re: [PATCH v5 4/8] ima: define a new template field 'd-type' and a
 new template 'ima-ngv2'
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 25 Feb 2022 15:01:37 -0500
In-Reply-To: <YhfSgeldgCcnzszw@sol.localdomain>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
         <20220211214310.119257-5-zohar@linux.ibm.com>
         <YhbSE/k4mElcehDN@sol.localdomain>
         <b89ec5792da3c284f8e5e058c5568482beccf00d.camel@linux.ibm.com>
         <YhfSgeldgCcnzszw@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3baPUHAscVM4coX-rxQfifQXK0NfEaqk
X-Proofpoint-ORIG-GUID: 3baPUHAscVM4coX-rxQfifQXK0NfEaqk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 adultscore=0 mlxlogscore=639 lowpriorityscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 2022-02-24 at 10:46 -0800, Eric Biggers wrote:
> > Thanks, Eric.  I really like your suggestion.  Currently, type is
> > defined as either "ima" or "verity".   Are you ok with prefixing each
> > record with these strings?
> > 
> 
> As I mentioned before I think "full_hash" would be more descriptive than "ima".
> (All of this is part of IMA.)  It's up to you though.

Sorry, to me that doesn't sense.  Either we use "full_hash" and
"Merkle-tree", or "ima" and "verity".

-- 
thanks,

Mimi

